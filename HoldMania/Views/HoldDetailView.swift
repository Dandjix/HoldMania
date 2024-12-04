//
//  HoldDetailView.swift
//  HoldMania
//
//  Created by unger tristan on 04/12/2024.
//

import SwiftUI

struct HoldDetailView: View {
    var hold: Hold

    var body: some View {
        VStack {
            Image(hold.imageURL)
                .resizable()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
            Text(hold.type)
                .font(.largeTitle)
                .bold()
            Text("Poids: \(hold.weight)g")
            Text("Taille: \(hold.size)")
            Text("Prix: \(hold.price, specifier: "%.2f") €")
            
            Button(action: {
                // Ajouter au panier (à implémenter)
            }) {
                Text("Ajouter au panier")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .navigationTitle("Détails")
    }
}



