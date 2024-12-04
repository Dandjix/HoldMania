//
//  CartView.swift
//  HoldMania
//
//  Created by unger tristan on 04/12/2024.
//

import SwiftUI

struct CartView: View {
    @StateObject private var cartViewModel = CartViewModel()
    
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
                            Text(item.hold.type)
                            Spacer()
                            Text("x\(item.quantity)")
                            Spacer()
                            Text("\(item.totalPrice, specifier: "%.2f") €")
                        }
                    }
                    
                    Text("Total: \(cartViewModel.totalPrice, specifier: "%.2f") €")
                        .font(.title)
                        .padding()
                    
                    Button("Valider le panier") {
                        // Action pour valider le panier
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
    
    struct CartView_Previews: PreviewProvider {
        static var previews: some View {
            CartView()
        }
    }

}



