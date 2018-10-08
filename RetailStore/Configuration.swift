//
//  Configuration.swift
//  RetailStore
//
//  Created by Jitendra on 08/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

struct Configuration {
    
    static let url              = "https://server-url.com/"
    
    static let pageSize         = 15
    
    static let storeName        = "Fantastic Store"

    static let defaultCurrency  = "USD"

    static let currencySymbol   = "$"

    static let minimumCartValue = 49.99

    static let useStub          = true

    static func checkConfiguration() {
        
        if url.isEmpty || pageSize < 0 {
            fatalError("""
                Invalid configuration found.
            """)
        }
    }
}
