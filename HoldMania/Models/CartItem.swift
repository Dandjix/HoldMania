//
//  CartItem.swift
//  HoldMania
//
//  Created by unger tristan on 04/12/2024.
//

import Foundation

struct CartItem: Identifiable,Decodable {
    var id: Int
    var hold: Hold
    var quantity: Int
    
    var totalPrice: Double {
        return Double(quantity) * (hold.priceAsDouble ?? 0.0)
    }
}
