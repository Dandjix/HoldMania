//
//  ContentView.swift
//  HoldMania
//
//  Created by dubreuil timon on 03/12/2024.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var userViewModel : UserViewModel
    
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
                    .disabled(userViewModel.user != nil)
                    .opacity(userViewModel.user != nil ? 0.5 : 1)
                
                OrderView()
                    .tabItem {
                        Label("Commandes", systemImage: "cart")
                    }
                    .disabled(userViewModel.user != nil)
                    .opacity(userViewModel.user != nil ? 0.5 : 1)
                
                AccountView()
                    .tabItem {
                        Label("Compte", systemImage: "person")
                    }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        
        static var previews: some View {
            ContentView()
                .environmentObject(CartViewModel())
                .environmentObject(UserViewModel())
                .environmentObject(OrderViewModel())
        }
    }


}

#Preview {
    ContentView()
}
