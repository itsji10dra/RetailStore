//
//  CartItem.swift
//  RetailStore
//
//  Created by Jitendra on 10/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import Foundation

struct CartItem: Cartable {

    let id: Int32
        
    let title: String
    
    let thumbImage: URL
    
    let price: Double

    var quantity: UInt = 1
    
    init(item: Sellable, quantity: UInt) {
        self.id = item.id
        self.title = item.title
        self.thumbImage = item.thumbImage
        self.price = item.price
        self.quantity = quantity
    }
}
