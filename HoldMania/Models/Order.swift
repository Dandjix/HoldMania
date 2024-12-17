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
    var dateOrder : String
    var isSent : Int
    var totalOrderPrice : String
    var totalNumberOfHolds : String

    private enum CodingKeys: String, CodingKey {
        case idOrder
        case dateOrder
        case isSent
        case totalOrderPrice
        case totalNumberOfHolds
    }
    
    
}
extension Order {
    var dateOrderAsDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter.date(from: dateOrder)
    }
    var formattedDateOrder: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: dateOrderAsDate ?? Date()) 
    }
    
    var totalOrderPriceAsDouble: Double {
        return Double(totalOrderPrice)!
    }
    
    var totalNumberOfHoldsAsInt: Int {
        return Int(totalNumberOfHolds)!
    }
    
    var isSentAsBool: Bool {
        return isSent == 1
    }

    
}
