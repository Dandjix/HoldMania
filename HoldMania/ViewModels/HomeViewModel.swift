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
        fetchHolds() // Charger les données à l'initialisation
    }

    private func fetchHolds() {
        guard let url = URL(string: "\(API.baseURL)/holds") else {
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
