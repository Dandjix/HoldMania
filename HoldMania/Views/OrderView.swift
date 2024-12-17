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
                HStack{
                    Text("order")
                    Text("\(order.totalNumberOfHolds), sent : \(order.isSent)")
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
            
            Text("number of orders : \(orderViewModel.orders)")
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
