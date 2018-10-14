//
//  StoredCartItemsTests.swift
//  RetailStoreTests
//
//  Created by Jitendra on 14/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import XCTest
@testable import RetailStore

class StoredCartItemsTests: XCTestCase {
    
    func testConvertToStorage() {
        
        let cartItem = CartItem(id: 15,
                                title: "Sample Descripition",
                                thumbImage: URL(string: "https://example.com/image.jpeg")!,
                                price: 62.22,
                                quantity: 8)
        
        let storedCartItem = cartItem.convertToStorage()
        XCTAssertEqual(cartItem.id, storedCartItem.id)
        XCTAssertEqual(cartItem.title, storedCartItem.title)
        XCTAssertEqual(cartItem.thumbImage.lastPathComponent, storedCartItem.imageName)
        XCTAssertEqual(cartItem.price, storedCartItem.price)
        XCTAssertEqual(cartItem.quantity, UInt(storedCartItem.quantity))
    }
    
    func testConvertFromStorage() {

        let storedCartItem = StoredCartItem()
        storedCartItem.id = 5
        storedCartItem.title = "Test Item"
        storedCartItem.imageName = "image.png"
        storedCartItem.price = 562.32
        storedCartItem.quantity = 4

        let cartItem = CartItem.convertFromStorage(storedCartItem)
        XCTAssertEqual(cartItem.id, storedCartItem.id)
        XCTAssertEqual(cartItem.title, storedCartItem.title)
        XCTAssertEqual(cartItem.thumbImage.lastPathComponent, storedCartItem.imageName)
        XCTAssertEqual(cartItem.price, storedCartItem.price)
        XCTAssertEqual(cartItem.quantity, UInt(storedCartItem.quantity))

        if let cacheDirPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let url = cacheDirPath.appendingPathComponent(storedCartItem.imageName)
            XCTAssertEqual(cartItem.thumbImage, url)
        } else {
            XCTFail("Failed to get library path.")
        }
    }
}
