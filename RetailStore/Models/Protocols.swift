//
//  Shopable.swift
//  RetailStore
//
//  Created by Jitendra on 10/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import Foundation

protocol Sellable {
    
    var id: Int32 { get }
    
    var title: String { get }
    
    var thumbImage: URL { get }
    
    var price: Double { get }
}

protocol Cartable: Sellable {
    
    var quantity: UInt { get set }
    
    init(item: Sellable, quantity: UInt)
}
