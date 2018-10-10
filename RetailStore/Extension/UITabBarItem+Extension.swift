//
//  UITabBarItem+Extension.swift
//  RetailStore
//
//  Created by Jitendra on 10/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import UIKit

private var identifierKey: UInt8 = 0

extension UITabBarItem {
    
    @IBInspectable var identifier: String? {
        get {
            return objc_getAssociatedObject(self, &identifierKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &identifierKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}
