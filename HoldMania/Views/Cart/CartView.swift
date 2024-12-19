//
//  CartView.swift
//  HoldMania
//
//  Created by unger tristan on 04/12/2024.
//

import SwiftUI

struct CartView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = CartViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.items.isEmpty {
                    VStack {
                        Text("Votre panier est vide.")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.items) { item in
                            CartRowView(
                                orderItem: item,
                                onUpdateQuantity: { updatedItem, delta in
                                    viewModel.updateCartQuantity(holdId: updatedItem.idHold, quantity: updatedItem.quantity + delta)
                                }
                            )
                        }
                    }
                    .listStyle(.plain)
                }

                if !viewModel.items.isEmpty {
                    VStack {
                        HStack {
                            Text("Total :")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            Text(String(format: "%.2f €", viewModel.totalPrice))
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)

                        Button(action: {
                            print("Commande validée !")
                        }) {
                            Text("Acheter")
                                .font(.headline)
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(Color.blue)
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
            .navigationTitle("Votre Panier")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Fermer") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                viewModel.load(userId: 1) // Change to appropriate userId
            }
        }
    }
}
