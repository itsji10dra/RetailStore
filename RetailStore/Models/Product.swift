//
//  Product.swift
//  RetailStore
//
//  Created by Jitendra on 08/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import Foundation

struct Product: Sellable, Decodable {
    
    let id: Int32
    
    let title: String
    
    let thumbImage: URL
    
    let price: Double
}
