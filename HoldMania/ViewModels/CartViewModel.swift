//
//  CartViewModel.swift
//  HoldMania
//
//  Created by unger tristan on 04/12/2024.
//

import Foundation

class CartViewModel: ObservableObject {
    @Published var items: [CartItem] = []
    
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.totalPrice }
    }
    
    func addItem(hold: Hold) {
        if let index = items.firstIndex(where: { $0.hold.id == hold.id }) {
            items[index].quantity += 1
        } else {
            let newItem = CartItem(id: items.count + 1, hold: hold, quantity: 1)
            items.append(newItem)
        }
    }
    
    func removeItem(id: Int) {
        if let index = items.firstIndex(where: { $0.id == id }) {
            items.remove(at: index)
        }
    }
}
