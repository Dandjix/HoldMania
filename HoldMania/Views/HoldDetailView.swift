import SwiftUI

struct HoldDetailView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    
    var hold: Hold

    @State private var quantityInCart: Int = 0
    @State private var isModified: Bool = false

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

            HStack {
                Button(action: decrementQuantity) {
                    Text("v")
                        .font(.largeTitle)
                        .frame(width: 40, height: 40)
                        .background(Color.pink.opacity(0.85))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .baselineOffset(2*Double.pi)
                }
                
                Text("\(quantityInCart)") // Affiche la quantité actuelle
                    .font(.title)
                    .padding()

                Button(action: incrementQuantity) {
                    Text("ʌ")
                        .font(.largeTitle)
                        .frame(width: 40, height: 40)
                        .background(Color.green.opacity(0.85))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .baselineOffset(2*Double.pi)

                }
            }

            Spacer()

            // Affiche le bouton selon l'état de connexion
            if userViewModel.isLoggedIn() {
                Button(action: updateCart) {
                    Text(isModified ? "Valider les modifications" : "Valider")
                        .padding()
                        .background(isModified ? Color.orange : Color.blue) // Changer la couleur si modifié
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(!isModified)
            } else {
                NavigationLink(destination: AccountView()) {
                    Text("Se connecter")
                        .padding()
                        .background(Color.pink.opacity(0.85))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .navigationTitle("Détails de la Prise")
        .padding()
//        .onAppear {
//            self.quantityInCart = cartViewModel.getQuantityInCart(for: hold)
//        }
    }
    private func incrementQuantity() {
        quantityInCart += 1
        isModified = true
    }

    private func decrementQuantity() {
        if quantityInCart > 0 {
            quantityInCart -= 1
        }
        isModified = true
    }

    private func updateCart() {
//            cartViewModel.updateCartQuantity(for: hold, quantity: quantityInCart)
        isModified = false
    }
}

