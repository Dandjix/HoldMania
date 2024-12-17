//
//  UserViewModel.swift
//  HoldMania
//
//  Created by dubreuil timon on 17/12/2024.
//

import Foundation
import Combine

class UserViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    func login(email: String, completion: @escaping (Bool, Error?) -> Void) {
        guard !email.isEmpty else {
            completion(false, NSError(domain: "InvalidEmail", code: 400, userInfo: [NSLocalizedDescriptionKey: "L'email est vide."]))
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let urlString = "\(API.baseURL)/users/connectByEmail?email=\(email)"
        guard let url = URL(string: urlString) else {
            completion(false, NSError(domain: "InvalidURL", code: 400, userInfo: [NSLocalizedDescriptionKey: "URL invalide."]))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = "Erreur réseau : \(error.localizedDescription)"
                    completion(false, error)
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "Aucune donnée reçue."
                    completion(false, NSError(domain: "NoData", code: 500, userInfo: [NSLocalizedDescriptionKey: "Aucune donnée reçue."]))
                    return
                }

                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    self.user = user
                    completion(true, nil)
                } catch {
                    self.errorMessage = "Impossible de décoder les données."
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
    
    func isLoggedIn() -> Bool
    {
        return user != nil
    }
}
