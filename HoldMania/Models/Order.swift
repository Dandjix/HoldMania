//
//  Order.swift
//  HoldMania
//
//  Created by dubreuil timon on 17/12/2024.
//

import Foundation

struct Order: Identifiable, Decodable {
    var id: Int { idOrder } // Mapper idHold vers id pour SwiftUI
    var idOrder : Int
    var dateOrder : Date
    var isSent : Bool
    var totalOrderPrice : String
    var totalNumberOfHolds : Int

    private enum CodingKeys: String, CodingKey {
        case idOrder
        case dateOrder
        case isSent
        case totalOrderPrice
        case totalNumberOfHolds
    }
    
    
}
extension Order {
    var totalOrderPriceAsDouble: Double? {
        Double(totalOrderPrice)
    }
}
