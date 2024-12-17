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
        List(orderViewModel.orders){ order in
            Text("order")
            Text("\(order.totalNumberOfHolds), sent : \(order.isSent)")
        }
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
