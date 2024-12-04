//
//  HomeView.swift
//  HoldMania
//
//  Created by unger tristan on 04/12/2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.holds) { hold in
                NavigationLink(destination: HoldDetailView(hold: hold)) {
                    HStack {
                        Image(hold.imageURL)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        VStack(alignment: .leading) {
                            Text(hold.type)
                                .font(.headline)
                            Text("Poids: \(hold.weight)g")
                                .font(.subheadline)
                            Text("Taille: \(hold.size)")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("Catalogue")
        }
    }
    
    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            HomeView()
        }
    }

}
