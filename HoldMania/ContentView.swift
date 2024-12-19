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
    @EnvironmentObject var homeViewModel : HomeViewModel
    
    @State private var selectedTab = 0
    
    var body: some View {
            TabView(selection: $selectedTab) {
                HomeView(selectedTab: $selectedTab)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(0)
                
                if userViewModel.isLoggedIn() {
                    CartView()
                        .tabItem {
                            Label("Panier", systemImage: "cart")
                        }
                        .tag(1)
                    
                    OrderView()
                        .tabItem {
                            Label("Commandes", systemImage: "truck.box.fill")
                        }
                        .tag(2)
                }
                
                AccountView()
                    .tabItem {
                        Label("Compte", systemImage: "person")
                    }
                    .tag(3)
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        
        static var previews: some View {
            ContentView()
                .environmentObject(CartViewModel())
                .environmentObject(UserViewModel())
                .environmentObject(OrderViewModel())
                .environmentObject(HomeViewModel())
                .environmentObject(SearchHoldViewModel())
        }
    }


}

#Preview {
    ContentView()
        .environmentObject(CartViewModel())
        .environmentObject(UserViewModel())
        .environmentObject(OrderViewModel())
}
