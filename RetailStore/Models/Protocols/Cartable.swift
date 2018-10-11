//
//  Cartable.swift
//  RetailStore
//
//  Created by Jitendra on 12/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

protocol Cartable: Sellable {
    
    var quantity: UInt { get set }
    
    init(item: Sellable, quantity: UInt)
}
