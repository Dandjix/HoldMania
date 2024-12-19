//
//  OrderView.swift
//  HoldMania
//
//  Created by dubreuil timon on 17/12/2024.
//

import Foundation


import SwiftUI

struct OrderView: View {
    @EnvironmentObject var orderViewModel : OrderViewModel
    
    var body: some View {
        
        VStack{
            List(orderViewModel.orders){ order in
                VStack{
                    Text("Nombre de prises totales dans la commande : \(order.totalNumberOfHoldsAsInt)")
                    Text("Prix total : \(order.totalOrderPriceAsDouble,specifier: "%.2f")")
                    Text("Date d'achat : \(order.formattedDateOrder)")
                }
            }
            
            if(orderViewModel.isLoading)
            {
                Text("loading ...")
            }
            
            if(orderViewModel.errorMessage != nil)
            {
                Text("Error : \(orderViewModel.errorMessage ?? "invalid error message")")
            }
        }
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView()
            .environmentObject(UserViewModel())
            .environmentObject(OrderViewModel())
            .environmentObject(CartViewModel())
    }
}
