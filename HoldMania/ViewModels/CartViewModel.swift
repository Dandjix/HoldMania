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
    
    func load(userId: Int) async throws {
        print("Loading cart...")

        self.isLoading = true
        defer { self.isLoading = false } // Ensure `isLoading` is reset when the function exits

        // Construct URL
        guard let url = URL(string: "\(API.baseURL)/orders/\(userId)") else {
            throw CartError.invalidURL
        }

        do {
            // Fetch data from the server
            
            let (data, response) = try await URLSession.shared.data(from: url)

            print("got data from request")
            
            // Validate the HTTP response
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw CartError.internalError
            }

            print("past guard")
            
            var decodedOrders : [Order] = []
            // Decode orders
            do
            {
                decodedOrders = try JSONDecoder().decode([Order].self, from: data)
            }
            catch
            {
                print("decoding orders failed")
                throw CartError.internalError
            }
            decodedOrders = decodedOrders.filter { !$0.isSentAsBool }

            print("past decoder")
            
            if decodedOrders.isEmpty {
                // Create a new cart if no orders exist
                let orderId = try await createCart(userId: userId)
                self.cartId = orderId
                
                print("load from no cart")
                try await loadCartItems(cartId: orderId)
                print("done")
            } else if decodedOrders.count == 1 {
                // Use the existing cart
                let cartId = decodedOrders[0].idOrder
                self.cartId = cartId
                print("load from cart exists")
                try await loadCartItems(cartId: cartId)
                print("done")
            } else {
                print("more than 1 cart")
                // Handle multiple carts
                throw CartError.multipleCartsNotAllowed
            }
        } catch {
            self.errorMessage = "Erreur : \(error.localizedDescription)"
            throw error
        }
    }
    
    
    func createCart(userId: Int) async throws -> Int {
        guard let url = URL(string: "\(API.baseURL)/orders/\(userId)") else {
            throw CartError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw CartError.internalError
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let idOrder = json["idOrder"] as? Int {
                return idOrder
            } else {
                throw CartError.internalError
            }
        } catch {
            throw CartError.internalError
        }
    }


    func loadCartItems(cartId: Int) async throws {
        guard let url = URL(string: "\(API.baseURL)/orders/lines/\(cartId)") else {
            throw CartError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw CartError.internalError
        }
        
        do {
            let items = try JSONDecoder().decode([OrderItem].self, from: data)
            self.items = items
            self.errorMessage = nil
        } catch {
            self.errorMessage = "Erreur lors de la lecture des articles du panier."
            throw CartError.internalError
        }
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
                    Task{
                        await self.refreshCart() // Refresh cart regardless of outcome
                    }
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
                    Task{
                        await self.refreshCart() // Refresh cart regardless of outcome
                    }
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
                    Task{
                        await self.refreshCart() // Refresh cart regardless of outcome
                    }

                }
            }.resume()
        }
    }
    
    func validateCart(idClient: Int) async {
        guard let url = URL(string: "\(API.baseURL)/orders?idOrder=\(self.cartId)") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"

        do {
            let (_, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Server responded with an error")
                return
            }

            print("PATCH request succeeded")

            // Load the cart for the user asynchronously
            do {
                try await self.load(userId: idClient)
            } catch {
                print("Error loading cart: \(error.localizedDescription)")
            }
        } catch {
            print("Error making PATCH request: \(error.localizedDescription)")
        }
    }


    private func refreshCart() async {
        do {
            try await loadCartItems(cartId: self.cartId)
            self.errorMessage = nil // Clear error if successful
        }catch{
            self.errorMessage = "could not refresh cart" // Clear error if successful
        }
    }


}
