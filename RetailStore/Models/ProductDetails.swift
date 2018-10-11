//
//  ProductDetails.swift
//  RetailStore
//
//  Created by Jitendra on 10/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import Foundation

struct ProductDetails: Sellable, Decodable {
    
    let id: Int32
        
    let title: String
    
    let thumbImage: URL
    
    let price: Double
    
    let images: [URL]
    
    let description: String
}
