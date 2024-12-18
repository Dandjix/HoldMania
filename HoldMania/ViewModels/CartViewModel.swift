//
//  CartViewModel.swift
//  HoldMania
//
//  Created by unger tristan on 04/12/2024.
//

import Foundation

enum CartError : Error
{
    case multipleCartsNotAllowed
    case invalidURL
    case internalError
}


class CartViewModel: ObservableObject {
    @Published var items: [OrderItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage : String? = nil
    @Published var cartId : Int = -1
        
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.totalPriceAsDouble }
    }
    
    func load(userId: Int, completion: @escaping (Bool, Error?) -> Void = { _,_ in }) {
        isLoading = true
        guard let url = URL(string: "\(API.baseURL)/orders/\(userId)") else {
            errorMessage = "URL invalide"
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Erreur réseau : \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "Aucune donnée reçue."
                    return
                }
                

                do {
                    var decodedOrders = try JSONDecoder().decode([Order].self, from: data)
                    
                    decodedOrders = decodedOrders.filter{!$0.isSentAsBool}
                    
                    if(decodedOrders.count == 0)
                    {
                        self?.createOrder(userId: userId, completion: { orderId, error in
                            if error == nil{
                                self?.cartId = orderId
                                self?.loadCartItems(cartId: orderId, completion: completion)
                            } else {
                                self?.errorMessage = "Failed to create order"
                                completion(false, error)
                            }
                        })
                    }
                    else if(decodedOrders.count == 1)
                    {
                        let cartId = decodedOrders[0].idOrder
                        self?.cartId = cartId
                        self?.loadCartItems(cartId: cartId, completion: completion)
                    }
                    else
                    {
                        throw CartError.multipleCartsNotAllowed
                    }
                    
                    self?.isLoading = false
                    
                } catch CartError.multipleCartsNotAllowed {
                    self?.errorMessage = "Erreur : Plusieurs paniers détectés."
                    completion(false, CartError.multipleCartsNotAllowed)
                } catch {
                    self?.errorMessage = "Erreur lors de la lecture des données."
                    completion(false, error)
                }
            }
        }.resume()
    }
    
    
    func createOrder(userId: Int, completion: @escaping (Int, Error?) -> Void) {
        guard let url = URL(string: "\(API.baseURL)/orders/\(userId)") else {
            completion(-1, CartError.invalidURL)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Construct the new order object or payload (customize based on your API requirements)
        let newOrder = ["userId": userId]  // Example payload, customize based on your needs
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: newOrder, options: [])
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(-1, error)
                        return
                    }
                    
                    guard let data = data else {
                        completion(-1, CartError.internalError)
                        return
                    }
                    
                    do {
                        let order = try JSONDecoder().decode(Order.self, from: data)
                        completion(order.id, nil)
                    } catch {
                        completion(-1, error)
                    }
                }
            }.resume()
            
        } catch {
            completion(-1, error)
        }
    }

    // Helper function to load cart items (GET request)
    func loadCartItems(cartId: Int, completion: @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: "\(API.baseURL)/orders/lines/\(cartId)") else {
            completion(false, CartError.invalidURL)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Erreur réseau : \(error.localizedDescription)"
                    completion(false, error)
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "Aucune donnée reçue."
                    completion(false, nil)
                    return
                }
                
                do {
                    // Decode the cart items (assuming an appropriate struct for items)
                    let items = try JSONDecoder().decode([OrderItem].self, from: data)
                    self.items = items  // Store the cart items
                    self.errorMessage = nil
                    completion(true, nil)  // Success
                } catch {
                    self.errorMessage = "Erreur lors de la lecture des articles du panier."
                    completion(false, error)
                }
            }
        }.resume()
    }
    
    
    func updateCartQuantity(hold: Hold, quantity: Int) {
        let holdId = hold.id
        let cartId = self.cartId
        
        guard cartId != -1 else {
            self.errorMessage = "Cart ID invalide."
            return
        }
        
        if quantity == 0 {
            // DELETE /orders/lines?idOrder=cartId&idHold=holdId
            guard let url = URL(string: "\(API.baseURL)/orders/lines?idOrder=\(cartId)&idHold=\(holdId)") else {
                self.errorMessage = "URL invalide."
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.errorMessage = "Erreur réseau : \(error.localizedDescription)"
                    }
                    self.refreshCart() // Refresh cart regardless of outcome
                }
            }.resume()
            
        } else if items.contains(where: { $0.id == holdId }) {
            // PATCH /orders/lines?idOrder=cartId
            guard let url = URL(string: "\(API.baseURL)/orders/lines?idOrder=\(cartId)") else {
                self.errorMessage = "URL invalide."
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let updatePayload: [String: Any] = ["idHold": holdId, "quantity": quantity]
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: updatePayload, options: [])
                request.httpBody = jsonData
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            self.errorMessage = "Erreur réseau : \(error.localizedDescription)"
                        }
                        self.refreshCart() // Refresh cart regardless of outcome
                    }
                }.resume()
                
            } catch {
                self.errorMessage = "Erreur lors de la création du corps JSON."
            }
            
        } else {
            // POST /orders/lines?idOrder=cartId&idHold=holdId&quantity=quantity
            guard let url = URL(string: "\(API.baseURL)/orders/lines?idOrder=\(cartId)&idHold=\(holdId)&quantity=\(quantity)") else {
                self.errorMessage = "URL invalide."
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.errorMessage = "Erreur réseau : \(error.localizedDescription)"
                    }
                    self.refreshCart() // Refresh cart regardless of outcome
                }
            }.resume()
        }
    }

    // Helper function to refresh the cart
    private func refreshCart() {
        loadCartItems(cartId: self.cartId) { success, error in
            if let error = error {
                self.errorMessage = "Erreur lors de la mise à jour du panier : \(error.localizedDescription)"
            } else if !success {
                self.errorMessage = "La mise à jour du panier a échoué."
            } else {
                self.errorMessage = nil // Clear error if successful
            }
        }
    }
}
