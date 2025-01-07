//
//  ClientLevel.swift
//  HoldMania
//
//  Created by dubreuil timon on 19/12/2024.
//

import Foundation

struct ClientLevel: Identifiable, Decodable {
    var id: Int { idClientLevel } // Mapper idHold vers id pour SwiftUI
    let idClientLevel: Int
    let clientLevelName: String
    var selected : Bool = false

    private enum CodingKeys: String, CodingKey {
        case idClientLevel
        case clientLevelName
    }
}
