//
//  Hold.swift
//  HoldMania
//
//  Created by unger tristan on 04/12/2024.
//

import Foundation

struct Hold: Identifiable, Decodable {
    var id: Int { idHold } // Mapper idHold vers id pour SwiftUI
    let idHold: Int
    let holdColorName: String
    let holdTypeName: String
    let clientLevelName: String
    let holdName: String
    let price: String // Conserve price comme String
    let weight: String // Conserve weight comme String
    let sizeMeters: String // Conserve sizeMeters comme String
    let imageURL: String // Utilise String si les URLs ne sont pas utilisées directement

    private enum CodingKeys: String, CodingKey {
        case idHold
        case holdColorName
        case holdTypeName
        case clientLevelName
        case holdName
        case price
        case weight
        case sizeMeters
        case imageURL
    }
    
    
}

extension Hold {
    var priceAsDouble: Double? {
        Double(price)
    }

    var weightAsDouble: Double? {
        Double(weight)
    }

    var sizeMetersAsDouble: Double? {
        Double(sizeMeters)
    }
}
