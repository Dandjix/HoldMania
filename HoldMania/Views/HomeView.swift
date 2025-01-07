//
//  HomeView.swift
//  HoldMania
//
//  Created by unger tristan on 04/12/2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var homeViewModel : HomeViewModel // VueModel pour charger les données
    @EnvironmentObject private var searchHoldsViewModel : SearchHoldViewModel
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationView {
            VStack {
                
                SearchHolds()
                    .padding()
                
                if homeViewModel.isLoading {
                    ProgressView("Chargement des prises...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else if let errorMessage = homeViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    List(homeViewModel.holds) { hold in
                        NavigationLink(destination: HoldDetailView(selectedTab: $selectedTab, hold: hold)) {
                            HStack {
                                if UIImage(named: hold.imageURL) != nil {
                                    Image(hold.imageURL)
                                        .resizable()
                                        .frame(width: 70, height: 70)
                                        .clipShape(Circle())
                                } else {
                                    // Utilisation d'une icône SF Symbol par défaut
                                    Image(systemName: "photo.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .foregroundColor(.gray)
                                }
                                VStack(alignment: .leading) {
                                    Text(hold.holdName)
                                        .font(.headline)
                                    Text("Type : \(hold.holdTypeName)")
                                        .font(.subheadline)
                                    Text("Niveau : \(hold.clientLevelName)")
                                        .font(.subheadline)
                                    Text("Prix : \((hold.priceAsDouble ?? 0.0), specifier: "%.2f") €")
                                        .font(.subheadline)
                                }
                                .padding(.leading)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Catalogue des Prises")
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(selectedTab: .constant(0))
    }
}

