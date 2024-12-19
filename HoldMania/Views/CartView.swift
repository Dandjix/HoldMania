//
//  CartView.swift
//  HoldMania
//
//  Created by unger tristan on 04/12/2024.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var orderViewModel : OrderViewModel
    
    var body: some View {
        NavigationView {
            VStack {
//                Text("\(cartViewModel.cartId)")
                if cartViewModel.isLoading{
                    Text("Chargement...")
                }
                else if cartViewModel.errorMessage != nil
                {
                    Text("Cart error : \(cartViewModel.errorMessage ?? "Empty error")")
                }
                else if cartViewModel.items.isEmpty {
                    Text("Votre panier est vide.")
                        .font(.headline)
                        .padding()
                } else {
                    List(cartViewModel.items) { item in
                        HStack {
                            Text(item.holdName)
                            Spacer()
                            Text("x\(item.quantity)")
                            Spacer()
                            Text("\(item.totalPriceAsDouble, specifier: "%.2f") €")
                        }
                    }
                    
                    // Prix total pour tout le panier
                    Text("Total: \(cartViewModel.totalPrice, specifier: "%.2f") €")
                        .font(.title)
                        .padding()
                    
                    Button("Valider le panier") {
                        // Action pour valider le panier (ajout à la base de données, etc.)
                        Task {
                            // Await the validateCart method to ensure it's completed before continuing
                            await cartViewModel.validateCart(idClient: userViewModel.user!.idClient)
                            
                            print("idClient : \(userViewModel.user!.idClient)")
                            // After validateCart completes, load the order and cart details
                            orderViewModel.load(userId: userViewModel.user!.idClient)
                            cartViewModel.load(userId: userViewModel.user!.idClient)
                        }
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                
            }
            .navigationTitle("Panier")
        }
    }
}



