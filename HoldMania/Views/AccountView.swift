//
//  AccountView.swift
//  HoldMania
//
//  Created by unger tristan on 04/12/2024.
//

import SwiftUI

struct AccountView: View {
    @State private var name: String = ""
    @State private var firstname: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
            NavigationView {
                Form {
                    Section(header: Text("Informations personnelles")) {
                        TextField("Nom", text: $name)
                            .disabled(true)
                        TextField("Prénom", text: $firstname)
                            .disabled(true)
                        TextField("Téléphone", text: $phone)
                            .disabled(true)
                    }
                    
                    Section(header: Text("Entrez un email")) {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                        
                        Button(action: connect) {
                            if isLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                            } else {
                                Text("Se connecter")
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
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
            guard !email.isEmpty else {
                errorMessage = "Veuillez entrer une adresse email valide."
                return
            }
            errorMessage = nil
            isLoading = true

            // Construire l'URL
            let urlString = "\(API.baseURL)/users/connectByEmail?email=\(email)"
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
                        updateUI(with: user)
                    } catch {
                        errorMessage = "Mauvaise adresse email."
                    }
                }
            }
            task.resume()
        }

        private func updateUI(with user: User) {
            name = user.lastName
            firstname = user.firstName
            email = user.email
            phone = user.phoneNumber
            errorMessage = nil
        }
    }

    struct AccountView_Previews: PreviewProvider {
        static var previews: some View {
            AccountView()
        }
    }
