//
//  AccountView.swift
//  HoldMania
//
//  Created by unger tristan on 04/12/2024.
//

import SwiftUI

struct AccountView: View {
    @State private var name: String = "Doe"
    @State private var firstname: String = "John"
    @State private var email: String = "johndoe@example.com"
    @State private var phone: String = "123-456-7890"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informations personnelles")) {
                    TextField("Nom", text: $name)
                    TextField("Prénom", text: $firstname)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                    TextField("Téléphone", text: $phone)
                        .keyboardType(.phonePad)
                }
                
                Section {
                    Button(action: {
                        // Action pour sauvegarder les modifications
                    }) {
                        Text("Enregistrer")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
            }
            .navigationTitle("Compte")
        }
    }
    
    struct AccountView_Previews: PreviewProvider {
        static var previews: some View {
            AccountView()
        }
    }

}


