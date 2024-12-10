import SwiftUI

struct HoldDetailView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    
    var hold: Hold

    var body: some View {
        VStack {
            // Affiche l'image depuis l'URL avec un gestionnaire de chargement
            AsyncImage(url: hold.imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 200, height: 200)
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }

            // Affiche les informations détaillées
            Text(hold.name)
                .font(.largeTitle)
                .bold()
            Text("Type : \(hold.holdTypeName)")
                .font(.headline)
            Text("Couleur : \(hold.holdColorName)")
            Text("Niveau : \(hold.clientLevelName)")
            Text("Taille : \(hold.sizeMeters, specifier: "%.2f") m")
            Text("Poids : \(hold.weight, specifier: "%.2f") kg")
            Text("Prix : \(hold.price, specifier: "%.2f") €")
            
            // Bouton pour ajouter au panier
            Button(action: {
                cartViewModel.addItem(hold: hold)
            }) {
                Text("Ajouter au panier")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .navigationTitle("Détails de la Prise")
        .padding()
    }
}
