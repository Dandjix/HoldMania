//
//  ContentView.swift
//  HoldMania
//
//  Created by dubreuil timon on 03/12/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            CartView()
                .tabItem {
                    Label("Panier", systemImage: "cart")
                }
            
            AccountView()
                .tabItem {
                    Label("Compte", systemImage: "person")
                }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }


}

#Preview {
    ContentView()
}
