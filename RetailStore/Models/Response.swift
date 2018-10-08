//
//  Response.swift
//  RetailStore
//
//  Created by Jitendra on 08/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

struct Response<T>: Decodable where T: Decodable {
    
    let page: UInt
    
    let pageSize: UInt
    
    let totalPageCount: UInt
    
    let result: T
}
