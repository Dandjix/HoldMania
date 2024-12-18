//
//  CartItem.swift
//  HoldMania
//
//  Created by unger tristan on 04/12/2024.
//

import Foundation

struct OrderItem: Identifiable,Decodable {
    //{"quantity":1,"idHold":2,"holdName":"Prise GAMING","imageURL":"galactique","unitPrice":"11.50","totalPrice":"11.50"}
    
    var id: Int {idHold}
    var idHold : Int
    var holdName: String
    var imageURL : String
    var unitPrice : String
    var totalPrice : String
    
    var quantity: Int
}


extension OrderItem{
    
    var unitPriceAsDouble : Double {
        Double(unitPrice)!
    }
    
    var totalPriceAsDouble : Double {
        Double(totalPrice)!
    }
    
}
