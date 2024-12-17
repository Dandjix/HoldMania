//
//  UserSession.swift
//  HoldMania
//
//  Created by unger tristan on 17/12/2024.
//

import Foundation

class UserSession: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var name: String = ""
    @Published var firstname: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
}
