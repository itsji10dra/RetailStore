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
    
    private var cartItems: [CartItem] = [] {
        didSet {
            TabBarManager.default.updateCartBadge(value: "\(getCartItemsCount())")
        }
    }
    
    // MARK: - Public Methods
    
    public func deleteCartItemAt(index: Int) {
        cartItems.remove(at: index)
    }
    
    public func clearCart() {
        cartItems.removeAll()
    }
    
    public func updateCartItemQuantity(_ quantity: UInt, index: Int) {
        var item = cartItems.remove(at: index)
        item.quantity = quantity
        cartItems.insert(item, at: index)
    }
    
    public func addCartItem(_ item: Cartable, quantity: UInt) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            updateCartItemQuantity(quantity, index: index)
        } else {
            let cartItem = CartItem(item: item, quantity: quantity)
            cartItems.append(cartItem)
        }
    }
    
    public func quantityForItem(_ item: Cartable) -> UInt {
        return cartItems.first(where: { $0.id == item.id })?.quantity ?? 0
    }
    
    public func getCartItemsAtIndex(_ index: Int) -> CartItem? {
        return index < getCartItemsCount() ? cartItems[index] : nil
    }
    
    public func getCartItemsCount() -> Int {
        return cartItems.count
    }
}
