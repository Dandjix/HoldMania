//
//  HoldManiaApp.swift
//  HoldMania
//
//  Created by dubreuil timon on 03/12/2024.
//

//
//  JugShopApp.swift
//  JugShop
//
//  Created by unger tristan on 03/12/2024.
//

import SwiftUI

@main
struct HoldManiaApp: App {
    @StateObject private var cartViewModel = CartViewModel()
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var orderViewModel = OrderViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userViewModel)
                .environmentObject(cartViewModel)
                .environmentObject(orderViewModel)

        }
    }
}

