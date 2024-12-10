//
//  User.swift
//  HoldMania
//
//  Created by unger tristan on 04/12/2024.
//

import Foundation

struct User: Decodable {
    let idClient: Int
    let firstName: String
    let lastName: String
    let email: String
    let dateOfBirth: String
    let phoneNumber: String
    let clientLevelName: String
    let profilePictureURL: String
}

