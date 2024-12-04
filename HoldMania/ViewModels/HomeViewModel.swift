//
//  HomeViewModel.swift
//  HoldMania
//
//  Created by unger tristan on 04/12/2024.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var holds: [Hold] = [
        Hold(id: 1, name: "La prise du dragon", holdTypeName: "Jug", holdColorName: "Rouge", clientLevelName: "Débutant", sizeMeters: 0.4, weight: 14.2, price: 120.14, imageURL: URL(string: "https://example.com/jug1.png")!),
        Hold(id: 2, name: "La prise du dragon", holdTypeName: "Jug", holdColorName: "Rouge", clientLevelName: "Débutant", sizeMeters: 0.4, weight: 14.2, price: 120.14, imageURL: URL(string: "https://example.com/jug1.png")!)
    ]
}
