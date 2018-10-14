//
//  RealmTests.swift
//  RetailStoreTests
//
//  Created by Jitendra on 14/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import XCTest
import RealmSwift
@testable import RetailStore

class RealmTests: XCTestCase {

    override func setUp() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "TestingRealm"
    }
    
    func testSave() {
        let storedCartItem = StoredCartItem()
        storedCartItem.id = 5
        storedCartItem.title = "Test Item"
        storedCartItem.imageName = "image.png"
        storedCartItem.price = 562.32
        storedCartItem.quantity = 4

        let realm = try! Realm()
        try! realm.write {
            realm.add(storedCartItem)
        }

        let retrievedDelivery = realm.objects(StoredCartItem.self).first
        XCTAssertNotNil(retrievedDelivery)
        XCTAssertEqual(retrievedDelivery?.id, storedCartItem.id)
        XCTAssertEqual(retrievedDelivery?.title, storedCartItem.title)
        XCTAssertEqual(retrievedDelivery?.imageName, storedCartItem.imageName)
        XCTAssertEqual(retrievedDelivery?.price, storedCartItem.price)
        XCTAssertEqual(retrievedDelivery?.quantity, storedCartItem.quantity)
    }
    
    func testUpdate() {

        let storedCartItem = StoredCartItem()
        storedCartItem.id = 20
        storedCartItem.title = "Sample title"
        storedCartItem.imageName = "image.jpeg"
        storedCartItem.price = 33.4521
        storedCartItem.quantity = 6

        let realm = try! Realm()
        try! realm.write {
            realm.add(storedCartItem)
        }

        let updatedPrice = 39.4521
        let updatedQuantity = 2

        try! realm.write {
            storedCartItem.price = updatedPrice
            storedCartItem.quantity = updatedQuantity
        }

        let retrievedDelivery = realm.objects(StoredCartItem.self).first
        XCTAssertNotNil(retrievedDelivery)
        XCTAssertEqual(retrievedDelivery?.id, storedCartItem.id)
        XCTAssertEqual(retrievedDelivery?.title, storedCartItem.title)
        XCTAssertEqual(retrievedDelivery?.imageName, storedCartItem.imageName)
        XCTAssertEqual(retrievedDelivery?.price, updatedPrice)
        XCTAssertEqual(retrievedDelivery?.quantity, updatedQuantity)
    }
    
    func testDelete() {
        
        let storedCartItem1 = StoredCartItem()
        storedCartItem1.id = 5
        storedCartItem1.title = "Test Item 1"
        storedCartItem1.imageName = "image1.png"
        storedCartItem1.price = 562.32
        storedCartItem1.quantity = 7
        
        let storedCartItem2 = StoredCartItem()
        storedCartItem2.id = 6
        storedCartItem2.title = "Test Item 2"
        storedCartItem2.imageName = "image2.png"
        storedCartItem2.price = 52.32
        storedCartItem2.quantity = 2
        
        let storedCartItem3 = StoredCartItem()
        storedCartItem3.id = 8
        storedCartItem3.title = "Test Item 3"
        storedCartItem3.imageName = "image3.png"
        storedCartItem3.price = 56.32
        storedCartItem3.quantity = 5
        
        let realm = try! Realm()
        
        let cartItems = realm.objects(StoredCartItem.self)
        XCTAssertEqual(cartItems.count, 0)

        try! realm.write {
            realm.add([storedCartItem1, storedCartItem2, storedCartItem3])
        }
        XCTAssertEqual(cartItems.count, 3)
        
        try! realm.write {
            realm.delete(storedCartItem2)
        }
        XCTAssertEqual(cartItems.count, 2)

        try! realm.write {
            realm.deleteAll()
        }
        XCTAssertEqual(cartItems.count, 0)
    }
}
