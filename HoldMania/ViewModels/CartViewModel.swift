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
        
//        print("begin cart load")
        
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
                        self?.createCart(userId: userId, completion: { orderId, error in
                            if orderId != -1{
                                self?.cartId = orderId
                                self?.loadCartItems(cartId: orderId, completion: completion)
                            } else {
                                self?.errorMessage = "Failed to create order : \(error!)"
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
    
    
    func createCart(userId: Int, completion: @escaping (Int, Error?) -> Void) {
        guard let url = URL(string: "\(API.baseURL)/orders/\(userId)") else {
            completion(-1, CartError.invalidURL)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
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
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                         let idOrder = json["idOrder"] as? Int {
//                        print("success ! idOrder : \(idOrder)")
                          completion(idOrder, nil)
                      } else {
//                          print("Invalid JSON structure or `idOrder` not found")
                          completion(-1, CartError.internalError)
                      }
                } catch {
//                    print("data could not be decoded")
                    completion(-1, error)
                }
            }
        }.resume()
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
    
    func getQuantityInCart(holdId: Int) -> Int {
        if let orderItem = items.first(where: { $0.idHold == holdId }) {
            return orderItem.quantity
        } else {
            return 0
        }
    }

    func updateCartQuantity(holdId : Int, quantity: Int) {
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
            guard let url = URL(string: "\(API.baseURL)/orders/lines?idOrder=\(cartId)&idHold=\(holdId)&quantity=\(quantity)") else {
                self.errorMessage = "URL invalide."
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.errorMessage = "Erreur réseau : \(error.localizedDescription)"
                    }
                    self.refreshCart() // Refresh cart regardless of outcome
                }
            }.resume()
            
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
    
    func validateCart(idClient: Int) async {
        
//        print("validating cart ...")
        
        guard let url = URL(string: "\(API.baseURL)/orders?idOrder=\(self.cartId)") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        
        do {
//            print("awaiting...")
            // Perform the PATCH request and await the result
            let (_, response) = try await URLSession.shared.data(for: request)
            
//            print("await end")
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Server responded with an error")
                return
            }
            
            // Success: Proceed with the next steps
            DispatchQueue.main.async {
                print("PATCH request succeeded")
            }
        } catch {
            print("Error making PATCH request: \(error.localizedDescription)")
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
