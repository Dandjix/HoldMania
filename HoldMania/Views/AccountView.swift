//
//  AccountView.swift
//  HoldMania
//
//  Created by unger tristan on 04/12/2024.
//

import SwiftUI

struct AccountView: View {
    @State private var email: String = "john.doe@orange.fr"
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    
    @EnvironmentObject var userViewModel : UserViewModel
    @EnvironmentObject var orderViewModel : OrderViewModel
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
            NavigationView {
                Form {
                    if let user = userViewModel.user {
                        // Si les informations de l'utilisateur sont disponibles, on les affiche
                        Section(header: Text("Informations personnelles")) {
                            Text("Nom : \(user.lastName)")
                            Text("Prénom : \(user.firstName)")
                            Text("Téléphone : \(user.phoneNumber)")
                        }
                        
                        Section {
                            Button(action: logout) {
                                Text("Se déconnecter")
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.red)
                                    .cornerRadius(8)
                            }
                        }
                    } else {
                        // Affichage de l'interface de connexion
                        Section(header: Text("Entrez un email")) {
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                            
                            Button(action: login) {
                                if isLoading {
                                    ProgressView()
                                        .frame(maxWidth: .infinity)
                                } else {
                                    Text("Se connecter")
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }

                    if let errorMessage = errorMessage {
                        Section {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.footnote)
                        }
                    }
                }
                .navigationTitle("Compte")
            }
        }
    
    private func login() {
            guard !email.isEmpty else {
                errorMessage = "Veuillez entrer une adresse email valide."
                return
            }
            errorMessage = nil
            isLoading = true
            
            userViewModel.login(email: email) { success, error in
                DispatchQueue.main.async {
                    isLoading = false
                    if success {
                        orderViewModel.load(userId: userViewModel.user!.idClient)
                        // Les informations de l'utilisateur sont automatiquement mises à jour dans le ViewModel
                        self.presentationMode.wrappedValue.dismiss()

                    } else {
                        errorMessage = error?.localizedDescription ?? "Erreur de connexion."
                    }
                }
            }
        }
        
        private func logout() {
            userViewModel.logout() // Fonction de déconnexion
        }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(UserViewModel())
    }
}

