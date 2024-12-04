//
//  CartView.swift
//  HoldMania
//
//  Created by unger tristan on 04/12/2024.
//

import SwiftUI

struct CartView: View {
    @StateObject private var cartViewModel = CartViewModel() // Écoute les changements
    
    var body: some View {
        NavigationView {
            VStack {
                if cartViewModel.items.isEmpty {
                    Text("Votre panier est vide.")
                        .font(.headline)
                        .padding()
                } else {
                    List(cartViewModel.items) { item in
                        HStack {
                            // Utilisation des propriétés corrigées
                            Text(item.hold.name) // `name` au lieu de `type`
                            Spacer()
                            Text("x\(item.quantity)") // Quantité d'articles
                            Spacer()
                            Text("\(item.totalPrice, specifier: "%.2f") €") // Prix total par article
                        }
                    }
                    
                    // Prix total pour tout le panier
                    Text("Total: \(cartViewModel.totalPrice, specifier: "%.2f") €")
                        .font(.title)
                        .padding()
                    
                    Button("Valider le panier") {
                        // Action pour valider le panier (ajout à la base de données, etc.)
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



