//
//  StoredCartItem.swift
//  RetailStore
//
//  Created by Jitendra on 17/09/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import RealmSwift

class StoredCartItem: Object {
    
    @objc dynamic var id: Int32 = 0
    
    @objc dynamic var title: String = ""
    
    @objc dynamic var imageName: String = ""
    
    @objc dynamic var price: Double = 0.0
    
    @objc dynamic var quantity: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
