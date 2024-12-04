//
//  HomeViewModel.swift
//  HoldMania
//
//  Created by unger tristan on 04/12/2024.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var holds: [Hold] = [
        Hold(id: 1, type: "Jug", weight: 500, size: "Large", price: 19.99, imageURL: "jug1"),
        Hold(id: 2, type: "Crimp", weight: 200, size: "Small", price: 9.99, imageURL: "crimp1"),
        Hold(id: 3, type: "Sloper", weight: 350, size: "Medium", price: 14.99, imageURL: "sloper1")
    ]
}
