//
//  CartManager.swift
//  RetailStore
//
//  Created by Jitendra on 10/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

//-------------------------------------------------------------------------------------------------------------
// MARK: - StoreCartManager
//-------------------------------------------------------------------------------------------------------------

class StoreCartManager: CartManager<CartItem> {
    
    static let `default`: StoreCartManager = { return StoreCartManager() }()
    
    // Mark: - Initializers

    convenience override init() {
        let storableItems = RealmManager.shared.getAllObjects(CartItem.StorageClass.self)
        let cartItems = storableItems.map { CartItem.convertFromStorage($0) }
        self.init(cartItems: cartItems)
    }
    
    private init(cartItems: [CartItem]) {
        super.init()
        super.cartItems = cartItems
    }
    
    // Mark: - Override
    
    override func cartItemsDidUpdate() {
        let count = getCartItemsCount()
        let badgeValue: String? = count == 0 ? nil : "\(count)"
        TabBarManager.default.updateCartBadge(value: badgeValue)
        syncData()
    }
    
    override func clearCart() {
        super.clearCart()
        RealmManager.shared.deleteAllObjects()
    }
    
    @discardableResult
    override func deleteCartItemAt(index: Int) -> CartItem {
        let cartItem = super.deleteCartItemAt(index: index)
        let storableItem = cartItem.convertToStorage()
        RealmManager.shared.deleteObject(type: CartItem.StorageClass.self, primaryKey: storableItem.id)
        return cartItem
    }
    
    // Mark: - Private Methods
    
    private func syncData() {
        let storableItems = cartItems.map { $0.convertToStorage() }
        RealmManager.shared.saveObject(data: storableItems)
    }
}

//-------------------------------------------------------------------------------------------------------------
// MARK: - CartManager
//-------------------------------------------------------------------------------------------------------------

class CartManager<T> where T: Cartable {
    
    // MARK: - Data
    
    fileprivate var cartItems: [T] = [] {
        didSet {
            cartItemsDidUpdate()
        }
    }
    
    // Mark: - Open Methods
    
    open func cartItemsDidUpdate() {
        //Nothing to do internally
    }
    
    open func deleteCartItemAt(index: Int) -> T {
        return cartItems.remove(at: index)
    }
    
    open func clearCart() {
        cartItems.removeAll()
    }
    
    open func updateCartItemQuantity(_ quantity: UInt, index: Int) {
        var item = cartItems.remove(at: index)
        guard quantity > 0 else { return }
        item.quantity = quantity
        cartItems.insert(item, at: index)
    }
    
    open func addCartItem(_ item: T) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            updateCartItemQuantity(item.quantity, index: index)
        } else {
            cartItems.append(item)
        }
    }
    
    open func quantityForItem(_ item: Sellable) -> UInt {
        return cartItems.first(where: { $0.id == item.id })?.quantity ?? 0
    }
    
    open func getCartItemsAtIndex(_ index: Int) -> T? {
        return index < getCartItemsCount() ? cartItems[index] : nil
    }
    
    // Mark: - Final Methods
    
    public final func getCartItemsCount() -> Int {
        return cartItems.count
    }
    
    public final func getTotalPrice() -> Double {
        return cartItems.map { $0.price * Double($0.quantity) }.reduce(0, +)
    }
}
