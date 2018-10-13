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
    
    var totalPrice: Double {
        return price * Double(quantity)
    }

    init(id: Int32, title: String, thumbImage: URL, price: Double, quantity: UInt = 1) {
        self.id = id
        self.title = title
        self.thumbImage = thumbImage
        self.price = price
        self.quantity = quantity
    }
    
    init(item: Sellable, quantity: UInt) {
        self.init(id: item.id, title: item.title, thumbImage: item.thumbImage, price: item.price, quantity: quantity)
    }
}

extension CartItem: Storable {

    typealias StorageClass = StoredCartItem
    
    func convertToStorage() -> StoredCartItem {
        let storedItem = StoredCartItem()
        storedItem.id = self.id
        storedItem.title = self.title
        storedItem.imageName = self.thumbImage.lastPathComponent
        storedItem.price = self.price
        storedItem.quantity = Int(self.quantity)
        return storedItem
    }
    
    static func convertFromStorage(_ storage: StoredCartItem) -> CartItem {
        
        guard let cacheDirPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            fatalError("Unable to retrieve path to cache directory")
        }
        
        let cacheImagePath = cacheDirPath.appendingPathComponent(storage.imageName)
        
        return CartItem(id: storage.id,
                        title: storage.title,
                        thumbImage: cacheImagePath,
                        price: storage.price,
                        quantity: UInt(storage.quantity))
    }
}
