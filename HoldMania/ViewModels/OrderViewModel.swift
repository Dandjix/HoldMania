//
//  OrderViewModel.swift
//  HoldMania
//
//  Created by dubreuil timon on 17/12/2024.
//

import Foundation
import Combine

// Define custom error types for more clarity.
enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "L'URL est invalide."
        case .noData:
            return "Aucune donnée reçue."
        case .decodingError:
            return "Impossible de décoder les données."
        }
    }
}

class OrderViewModel: ObservableObject {
    @Published var orders: [Order] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    func load(userId: Int, completion: @escaping (Bool, Error?) -> Void = { _,_ in }) {
        isLoading = true
        guard let url = URL(string: "\(API.baseURL)/orders/\(userId)") else {
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
                

                do {
                    var decodedOrders = try JSONDecoder().decode([Order].self, from: data)
                    
                    decodedOrders = decodedOrders.filter{$0.isSentAsBool}
                    
                    self?.orders = decodedOrders
                    self?.errorMessage = nil
                } catch {
                    self?.errorMessage = "Erreur lors de la lecture des données."
                }
            }
        }.resume()
    }
}
