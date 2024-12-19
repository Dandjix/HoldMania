//
//  CartRowView.swift
//  HoldMania
//
//  Created by unger tristan on 19/12/2024.
//

import SwiftUI

struct CartRowView: View {
    @Binding var cartItem: Cart
    let onUpdateQuantity: (Cart, Int) async -> Void

    var body: some View {
        HStack {
            // Image du produit
            AsyncImage(url: URL(string: cartItem.imageurl)) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 80, height: 80)
            .cornerRadius(8)

            // Informations sur le produit
            VStack(alignment: .leading) {
                Text(cartItem.name)
                    .font(.headline)
                Text("Couleur: \(cartItem.color)")
                    .font(.subheadline)
                Text("\(cartItem.price, specifier: "%.2f") €")
                    .font(.subheadline)
            }

            Spacer()

            // Contrôle de la quantité
            VStack {
                HStack {
                    // Bouton pour diminuer la quantité
                    Button(action: {
                        Task {
                            await onUpdateQuantity(cartItem, -1) // Diminuer la quantité
                        }
                    }) {
                        Image(systemName: "minus.circle")
                            .foregroundColor(cartItem.quantity > 1 ? .blue : .gray)
                            .padding(8)
                    }
                    .contentShape(Rectangle())
                    .buttonStyle(BorderlessButtonStyle())

                    Text("\(cartItem.quantity)")
                        .font(.headline)
                        .frame(minWidth: 30)

                    // Bouton pour augmenter la quantité
                    Button(action: {
                        Task {
                            await onUpdateQuantity(cartItem, 1) // Augmenter la quantité
                        }
                    }) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.blue)
                            .padding(8)
                    }
                    .contentShape(Rectangle())
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
        }
    }
}

