//
//  CartManager.swift
//  RetailStore
//
//  Created by Jitendra on 10/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import Foundation

class CartManager {
    
    // MARK: - Singleton
    
    static let `default`: CartManager = { return CartManager() }()

    // MARK: - Data
    
    private lazy var cartItems: [CartItem] = []
    
    // MARK: - Public Methods
    
    public func deleteCartItemAt(index: Int) {
        self.cartItems.remove(at: index)
    }
    
    public func clearCart() {
        self.cartItems.removeAll()
    }
    
    public func updateCartItemQuantity(_ quantity: Int, index: Int) {
        var item = self.cartItems.remove(at: index)
        
        //Update quantity
        
        self.cartItems.insert(item, at: index)
    }
    
    public func addCartItem(_ item: CartItem) {
        
        self.cartItems.append(item)
    }
}
