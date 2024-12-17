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
    @Published var items: [CartItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage : String? = nil
        
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.totalPrice }
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
                    let items = try JSONDecoder().decode([CartItem].self, from: data)
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
    
    
    func addItem(hold: Hold) {
        if let index = items.firstIndex(where: { $0.hold.id == hold.id }) {
            items[index].quantity += 1
        } else {
            let newItem = CartItem(id: items.count + 1, hold: hold, quantity: 1)
            items.append(newItem)
        }
    }
    
    func removeItem(id: Int) {
        if let index = items.firstIndex(where: { $0.id == id }) {
            items.remove(at: index)
        }
    }
}
