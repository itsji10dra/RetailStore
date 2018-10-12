//
//  CartViewModel.swift
//  RetailStore
//
//  Created by Jitendra on 11/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import Foundation

class CartViewModel {    
    
    // MARK: - Public Methods
    
    public func loadData(handler: (ShoppingCartVC.CartDisplayInfo) -> Void) {
        
        let totalPriceValue = StoreCartManager.default.getTotalPrice()
        let totalPrice = Configuration.defaultCurrency + " " + String(format: "%.2f", totalPriceValue)
        let minimumPrice = "Minimum cart value must be $\(Configuration.minimumCartValue)"
        let isCartEmpty = StoreCartManager.default.getCartItemsCount() == 0
        
        let info = ShoppingCartVC.CartDisplayInfo(totalPriceValue: totalPriceValue,
                                                  totalPrice: totalPrice,
                                                  minimumCartPriceMessage: minimumPrice,
                                                  cartIsEmpty: isCartEmpty)
        handler(info)
    }
}
