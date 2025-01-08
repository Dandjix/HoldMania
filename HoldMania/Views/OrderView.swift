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
                VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "cart.fill")
                                    .foregroundColor(.blue)
                                Text("ID Commande : \(order.id)")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                            }
                            
                            HStack {
                                Text("Prises totales :")
                                    .fontWeight(.semibold)
                                Spacer()
                                Text("\(order.totalNumberOfHoldsAsInt)")
                            }
                            
                            HStack {
                                Text("Prix total :")
                                    .fontWeight(.semibold)
                                Spacer()
                                Text(String(format: "%.2f €", order.totalOrderPriceAsDouble))
                                    .foregroundColor(.green)
                            }
                            
                            HStack {
                                Text("Date d'achat :")
                                    .fontWeight(.semibold)
                                Spacer()
                                Text(order.formattedDateOrder)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
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
