//
//  AccountView.swift
//  HoldMania
//
//  Created by unger tristan on 04/12/2024.
//

import SwiftUI

struct AccountView: View {
    @State private var email: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    
    @EnvironmentObject var userViewModel : UserViewModel
    @EnvironmentObject var orderViewModel : OrderViewModel
    
    var body: some View {
        NavigationView {
            Form {
                if let user = userViewModel.user {
                    // If user data is loaded, show their personal info
                    Section(header: Text("Informations personnelles")) {
                        TextField("Nom", text: .constant(user.lastName))
                            .disabled(true)
                        TextField("Prénom", text: .constant(user.firstName))
                            .disabled(true)
                        TextField("Téléphone", text: .constant(user.phoneNumber))
                            .disabled(true)
                    }
                } else {
                    Text("Veuillez vous connecter pour afficher vos informations.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
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
                    orderViewModel.load(userId:userViewModel.user!.idClient)
                    // User data is updated automatically through the UserViewModel
                } else {
                    errorMessage = error?.localizedDescription ?? "Erreur de connexion."
                }
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}

