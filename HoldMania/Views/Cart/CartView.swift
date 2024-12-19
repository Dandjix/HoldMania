//
//  CartView.swift
//  HoldMania
//
//  Created by unger tristan on 04/12/2024.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    @EnvironmentObject private var orderViewModel: OrderViewModel

    var body: some View {
        VStack {
            if cartViewModel.isLoading {
                Text("Chargement...")
            } else if let errorMessage = cartViewModel.errorMessage {
                Text("Erreur : \(errorMessage)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else if cartViewModel.items.isEmpty {
                VStack {
                    Text("Votre panier est vide.")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(cartViewModel.items) { item in
                        CartRowView(
                            orderItem: item,
                            onUpdateQuantity: { updatedItem, delta in
                                cartViewModel.updateCartQuantity(holdId: updatedItem.idHold, quantity: updatedItem.quantity + delta)
                            }
                        )
                    }
                }
                .listStyle(.plain)

                VStack {
                    HStack {
                        Text("Total :")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        Text(String(format: "%.2f €", cartViewModel.totalPrice))
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)

                    Button(action: {
                        Task {
                            if let user = userViewModel.user {
                                await cartViewModel.validateCart(idClient: user.idClient)
                                orderViewModel.load(userId: user.idClient)
                            }
                        }
                    }) {
                        Text("Valider le panier")
                            .font(.headline)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .background(Color.white)
                .shadow(radius: 5)
            }
        }
    }
}
