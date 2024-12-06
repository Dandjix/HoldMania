//
//  HomeView.swift
//  HoldMania
//
//  Created by unger tristan on 04/12/2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel() // VueModel pour charger les données
    
    var body: some View {
        NavigationView {
            List(viewModel.holds) { hold in
                NavigationLink(destination: HoldDetailView(hold: hold)) {
                    HStack {
                        // Chargement d'une image à partir de l'URL
                        AsyncImage(url: hold.imageURL) { phase in
                            switch phase {
                            case .empty:
                                ProgressView() // Affiche un indicateur de chargement
                                    .frame(width: 50, height: 50)
                            case .success(let image):
                                image
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        VStack(alignment: .leading) {
                            // Affichage des propriétés du modèle Hold
                            Text(hold.name) // Affiche le nom de la prise
                                .font(.headline)
                            Text("Type : \(hold.holdTypeName)") // Type de la prise
                                .font(.subheadline)
                            Text("Couleur : \(hold.holdColorName)") // Couleur de la prise
                                .font(.subheadline)
                            Text("Niveau : \(hold.clientLevelName)") // Niveau d'utilisateur pour la prise
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("Catalogue des Prises") // Titre du catalogue
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

