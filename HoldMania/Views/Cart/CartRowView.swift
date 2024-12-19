//
//  CartRowView.swift
//  HoldMania
//
//  Created by unger tristan on 19/12/2024.
//
import SwiftUI

struct CartRowView: View {
    let orderItem: OrderItem
    let onUpdateQuantity: (OrderItem, Int) -> Void

    var body: some View {
        HStack {
            // Image du produit
            Image(orderItem.imageURL)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .cornerRadius(8)

            // Informations sur le produit
            VStack(alignment: .leading) {
                Text(orderItem.holdName)
                    .font(.headline)
                Text("\(orderItem.unitPrice) € / unité")
                    .font(.subheadline)
                Text("Total : \(orderItem.totalPrice) €")
                    .font(.subheadline)
            }

            Spacer()

            // Contrôle de la quantité
            VStack {
                HStack {
                    // Bouton pour diminuer la quantité
                    Button(action: {
                        if orderItem.quantity > 1 {
                            onUpdateQuantity(orderItem, -1)
                        } else {
                            onUpdateQuantity(orderItem, -orderItem.quantity) // Supprimer si quantité = 0
                        }
                    }) {
                        Image(systemName: orderItem.quantity > 1 ? "minus.circle" : "trash")
                            .foregroundColor(orderItem.quantity > 1 ? .blue : .red)
                            .padding(8)
                    }
                    .contentShape(Rectangle())
                    .buttonStyle(BorderlessButtonStyle())

                    Text("\(orderItem.quantity)")
                        .font(.headline)
                        .frame(minWidth: 30)

                    // Bouton pour augmenter la quantité
                    Button(action: {
                        onUpdateQuantity(orderItem, 1)
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
