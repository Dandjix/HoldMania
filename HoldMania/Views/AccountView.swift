//
//  AccountView.swift
//  HoldMania
//
//  Created by unger tristan on 04/12/2024.
//

import SwiftUI

struct AccountView: View {
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    @EnvironmentObject var userSession: UserSession

    var body: some View {
            NavigationView {
                Form {
                    if userSession.isLoggedIn {
                        Section(header: Text("Informations personnelles")) {
                            Text("Nom : \(userSession.name)")
                            Text("Prénom : \(userSession.firstname)")
                            Text("Téléphone : \(userSession.phone)")
                        }
                        
                        Section {
                            Button(action: disconnect) {
                                Text("Se déconnecter")
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.red)
                                    .cornerRadius(8)
                            }
                        }
                    } else {
                        Text("Veuillez vous connecter pour afficher vos informations.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    
                        TextField("Email", text: $userSession.email)
                            .keyboardType(.emailAddress)
                        
                        Button(action: connect) {
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

        private func connect() {
            guard !userSession.email.isEmpty else {
                errorMessage = "Veuillez entrer une adresse email valide."
                return
            }
            errorMessage = nil
            isLoading = true

            // Construire l'URL
            let urlString = "\(API.baseURL)/users/connectByEmail?email=\(userSession.email)"
            guard let url = URL(string: urlString) else {
                errorMessage = "URL invalide."
                isLoading = false
                return
            }

            // Effectuer la requête réseau
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    isLoading = false
                    
                    if let error = error {
                        errorMessage = "Erreur réseau : \(error.localizedDescription)"
                        return
                    }
                    
                    guard let data = data else {
                        errorMessage = "Aucune donnée reçue."
                        return
                    }
                    
                    // Décoder la réponse JSON
                    do {
                        let user = try JSONDecoder().decode(User.self, from: data)
                        updateGlobalSession(with: user)

                    } catch {
                        errorMessage = "Mauvaise adresse email."
                    }
                }
            }
            task.resume()
        }
    
        private func disconnect() {
            // Réinitialiser les données utilisateur et l'état de connexion
            userSession.isLoggedIn = false
            userSession.name = ""
            userSession.firstname = ""
            userSession.email = ""
            userSession.phone = ""
        }
    
        private func updateGlobalSession(with user: User) {
            // Mettre à jour les informations utilisateur globales
            userSession.name = user.lastName
            userSession.firstname = user.firstName
            userSession.email = user.email
            userSession.phone = user.phoneNumber
            userSession.isLoggedIn = true
        }

        
    }

    struct AccountView_Previews: PreviewProvider {
        static var previews: some View {
            AccountView()
                .environmentObject(UserSession())
        }
    }
