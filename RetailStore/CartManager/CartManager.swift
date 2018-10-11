//
//  CartManager.swift
//  RetailStore
//
//  Created by Jitendra on 10/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

class CartManager<T> where T: Cartable {
    
    // MARK: - Data
    
    private var cartItems: [T] = [] {
        didSet {
            cartItemsDidUpdate()
        }
    }
    
    // Mark: - Open Methods
    
    open func cartItemsDidUpdate() {
        //Nothing to do internally
    }
    
    // MARK: - Public Methods
    
    public final func deleteCartItemAt(index: Int) {
        cartItems.remove(at: index)
    }
    
    public final func clearCart() {
        cartItems.removeAll()
    }
    
    public final func updateCartItemQuantity(_ quantity: UInt, index: Int) {
        var item = cartItems.remove(at: index)
        guard quantity > 0 else { return }
        item.quantity = quantity
        cartItems.insert(item, at: index)
    }
    
    public final func addCartItem(_ item: Sellable, quantity: UInt) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            updateCartItemQuantity(quantity, index: index)
        } else {
            let cartItem = T(item: item, quantity: quantity)
            cartItems.append(cartItem)
        }
    }
    
    public final func quantityForItem(_ item: Sellable) -> UInt {
        return cartItems.first(where: { $0.id == item.id })?.quantity ?? 0
    }
    
    public final func getCartItemsAtIndex(_ index: Int) -> T? {
        return index < getCartItemsCount() ? cartItems[index] : nil
    }
    
    public final func getCartItemsCount() -> Int {
        return cartItems.count
    }
    
    public final func getTotalPrice() -> Double {
        return cartItems.map { $0.price }.reduce(0, +)
    }
}
