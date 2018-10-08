//
//  Product.swift
//  RetailStore
//
//  Created by Jitendra on 08/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import Foundation

struct Product: Decodable {
    
    let id: Int32
    
    let sectionId: Int32

    let title: String
    
    let image: URL
    
    let price: Double
}
