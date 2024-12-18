//
//  ContentView.swift
//  HoldMania
//
//  Created by dubreuil timon on 03/12/2024.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var userViewModel : UserViewModel
    @EnvironmentObject var orderViewModel : OrderViewModel
    @EnvironmentObject var cartViewModel : CartViewModel
    
    var body: some View {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                if userViewModel.isLoggedIn() {
                    CartView()
                        .tabItem {
                            Label("Panier", systemImage: "cart")
                        }
                    
                    OrderView()
                        .tabItem {
                            Label("Commandes", systemImage: "truck.box.fill")
                        }
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
                .environmentObject(CartViewModel())
                .environmentObject(UserViewModel())
                .environmentObject(OrderViewModel())
        }
    }


}

#Preview {
    ContentView()
        .environmentObject(CartViewModel())
        .environmentObject(UserViewModel())
        .environmentObject(OrderViewModel())
}
