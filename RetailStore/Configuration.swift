//
//  Configuration.swift
//  RetailStore
//
//  Created by Jitendra on 08/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

struct Configuration {
    
    static let url                      = "https://replace-me-with-server-url.com/"
    
    static let pageSize                 = 15                //Stub will be using page-size 15.
    
    static let storeName                = "Fantastic Store" //Name of store.

    static let defaultCurrency          = "USD"             //Currency to be used for products

    static let currencySymbol           = "$"               //Currency symbol of `defaultCurreny`

    static let minimumCartValue         = 49.99             //Minimum total price value for checkout

    static let maxQuantityAllowedInCart = 10                //Per item

    static let stubTimerDelay           = 0.3               //Loader to be shown while loading stub.
    
    static let useStubData              = true              //Will use, data from stub folder

    // Mark: - Methods
    
    static func checkConfiguration() {
        if (useStubData == false && stubTimerDelay < 0.3) ||
            (url.isEmpty || pageSize < 0) {
            fatalError("Invalid configuration found.")
        }
    }
}
