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
        let urlString = "\(API.baseURL)/orders/\(userId)"
        

        guard let components = URLComponents(string: urlString) else {
            errorMessage = NetworkError.invalidURL.localizedDescription
            completion(false, NetworkError.invalidURL)
            isLoading = false
            return
        }


        guard let url = components.url else {
            errorMessage = NetworkError.invalidURL.localizedDescription
            completion(false, NetworkError.invalidURL)
            isLoading = false
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Order].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completionStatus in
                self.isLoading = false
                switch completionStatus {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    completion(false, error)
                case .finished:
                    break
                }
            }, receiveValue: { orders in
                self.orders = orders
                completion(true, nil)
            })
            .store(in: &cancellables)
    }
}
