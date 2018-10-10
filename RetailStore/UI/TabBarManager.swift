//
//  TabBarManager.swift
//  RetailStore
//
//  Created by Jitendra on 10/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import UIKit

enum TabBarItemIds: String, CaseIterable {
    case shop   = "Shop"
    case cart   = "Cart"
    case profile = "Profile"
}

class TabBarManager {
    
    static let `default`: TabBarManager = { return TabBarManager() }()
    
    // MARK: - Data
    
    private let tabBarController: UITabBarController
    
    // MARK: - Initializer
    
    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let rootVC = appDelegate.window?.rootViewController as? UITabBarController else { fatalError("Default root is not a TabBarControlller") }
        self.init(tabBarController: rootVC)
    }
    
    private init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    // MARK: - Public Methods

    public func updateCartBadge(value: String?) {
        
        guard let allItems = tabBarController.tabBar.items,
            let cartTabBarItem = allItems.first(where: { $0.identifier == TabBarItemIds.cart.rawValue }) else { return }
        
        cartTabBarItem.badgeValue = value
    }
}
