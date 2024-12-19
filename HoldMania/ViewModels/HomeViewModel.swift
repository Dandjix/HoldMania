//
//  HomeViewModel.swift
//  HoldMania
//
//  Created by unger tristan on 04/12/2024.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var holds: [Hold] = [] // Liste vide au départ
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    init() {
        fetchHolds(colorOptions: [], levelOptions: [], searchName: "") // Charger les données à l'initialisation
    }

    public func fetchHolds(colorOptions : [Int], levelOptions : [Int], searchName : String) {
        
        var query : [String] = []
        
        if colorOptions.count > 0 {
            let colorString = colorOptions.map { String($0) }.joined(separator: ",")
            query.append("idColors=\(colorString)")
        }
        
        if levelOptions.count > 0 {
            let levelString = levelOptions.map { String($0) }.joined(separator: ",")
            query.append("idClientLevels=\(levelString)")
        }
        
        if(searchName != "")
        {
            let entry = "searchName=\(searchName)"
            query.append(entry)
        }
        
        //form query using ? and &
        let queryString = query.isEmpty ? "" : "?" + query.joined(separator: "&")
         
         // Form the complete URL by appending the query string to the base URL
         guard let url = URL(string: "\(API.baseURL)/holds\(queryString)") else {
             errorMessage = "URL invalide"
             return
         }
        
        isLoading = true // Démarrer le chargement
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false // Arrêter le chargement
                
                if let error = error {
                    self?.errorMessage = "Erreur réseau : \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "Aucune donnée reçue."
                    return
                }
                
                // Décoder les données reçues
                do {
                    let decodedHolds = try JSONDecoder().decode([Hold].self, from: data)
                    self?.holds = decodedHolds
                    self?.errorMessage = nil
                } catch {
                    self?.errorMessage = "Erreur lors de la lecture des données."
                }
            }
        }.resume()
    }
}
