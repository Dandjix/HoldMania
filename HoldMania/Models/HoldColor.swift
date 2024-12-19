//
//  HoldColor.swift
//  HoldMania
//
//  Created by dubreuil timon on 19/12/2024.
//

import Foundation

struct HoldColor: Identifiable, Decodable {
    var id: Int { idHoldColor } // Mapper idHold vers id pour SwiftUI
    let idHoldColor: Int
    let holdColorName: String
    var selected : Bool = false

    private enum CodingKeys: String, CodingKey {
        case idHoldColor
        case holdColorName
    }
}
