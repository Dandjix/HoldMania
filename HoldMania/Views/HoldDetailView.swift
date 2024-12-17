import SwiftUI

struct HoldDetailView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    
    var hold: Hold

    var body: some View {
        VStack {
            // Affiche l'image depuis l'URL avec un gestionnaire de chargement
            if UIImage(named: hold.imageURL) != nil {
                Image(hold.imageURL)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
            } else {
                // Utilisation d'une icône SF Symbol par défaut
                Image(systemName: "photo.fill")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .foregroundColor(.gray)
            }

            // Affiche les informations détaillées
            Text(hold.holdName)
                .font(.largeTitle)
                .bold()
            Text("Type : \(hold.holdTypeName)")
                .font(.headline)
            Text("Couleur : \(hold.holdColorName)")
            Text("Niveau : \(hold.clientLevelName)")
            Text("Taille : \((hold.sizeMetersAsDouble ?? 0.0), specifier: "%.2f") m")
            Text("Poids : \((hold.weightAsDouble ?? 0.0), specifier: "%.2f") kg")
            Text("Prix : \((hold.priceAsDouble ?? 0.0), specifier: "%.2f") €")
            
            Spacer()

            // Affiche le bouton selon l'état de connexion
            if userViewModel.isLoggedIn() {
                Button(action: {
                    cartViewModel.addItem(hold: hold)
                }) {
                    Text("Ajouter au panier")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            } else {
                NavigationLink(destination: AccountView()) {
                    Text("Se connecter")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .navigationTitle("Détails de la Prise")
        .padding()
    }
}
