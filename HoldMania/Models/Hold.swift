//
//  Hold.swift
//  HoldMania
//
//  Created by unger tristan on 04/12/2024.
//

import Foundation

struct Hold: Identifiable {
    var id: Int
    var name: String
    var holdTypeName: String
    var holdColorName: String
    var clientLevelName: String
    var sizeMeters: Double
    var weight: Double
    var price: Double
    var imageURL: URL
}
