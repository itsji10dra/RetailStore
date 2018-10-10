//
//  Product.swift
//  RetailStore
//
//  Created by Jitendra on 08/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import Foundation

protocol Cartable {
    
    var id: Int32 { get }
    
    var sectionId: Int32 { get }

    var title: String { get }

    var thumbImage: URL { get }

    var price: Double { get }
}

struct Product: Cartable, Decodable {
    
    let id: Int32
    
    let sectionId: Int32

    let title: String
    
    let thumbImage: URL
    
    let price: Double
}

struct ProductDetails: Cartable, Decodable {
    
    let id: Int32
    
    let sectionId: Int32
    
    let title: String
    
    let thumbImage: URL
    
    let price: Double

    let images: [URL]
    
    let description: String
}
