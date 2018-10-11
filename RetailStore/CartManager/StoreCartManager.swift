//
//  StoreCartManager.swift
//  RetailStore
//
//  Created by Jitendra on 11/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import Foundation

class StoreCartManager: CartManager<CartItem> {
    
    static let `default`: StoreCartManager = { return StoreCartManager() }()
    
    override func cartItemsDidUpdate() {
        let count = getCartItemsCount()
        let badgeValue: String? = count == 0 ? nil : "\(count)"
        TabBarManager.default.updateCartBadge(value: badgeValue)
    }
}
