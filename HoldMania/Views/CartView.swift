//
//  CartView.swift
//  HoldMania
//
//  Created by unger tristan on 04/12/2024.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    
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
                            Text(item.hold.holdName)
                            Spacer()
                            Text("x\(item.quantity)")
                            Spacer()
                            Text("\(item.totalPrice, specifier: "%.2f") €")
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



