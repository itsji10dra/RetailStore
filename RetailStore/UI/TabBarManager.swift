//
//  TabBarManager.swift
//  RetailStore
//
//  Created by Jitendra on 10/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import UIKit

class TabBarManager {
    
    // MARK: - Singleton

    static let `default`: TabBarManager = { return TabBarManager() }()
    
    // MARK: - Data
    
    enum TabBarItemIds: String {
        case shop   = "Shop"
        case cart   = "Cart"
        case profile = "Profile"
    }

    private let tabBarController: UITabBarController
    
    // MARK: - Initializer
    
    private convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let rootVC = appDelegate.window?.rootViewController as? UITabBarController else { fatalError("Default root is not a TabBarControlller") }
        self.init(tabBarController: rootVC)
    }
    
    public init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    // MARK: - Public Methods

    public func updateCartBadge(value: String?) {
        
        guard let allItems = tabBarController.tabBar.items,
            let cartTabBarItem = allItems.first(where: { $0.identifier == TabBarItemIds.cart.rawValue }) else { return }
        
        cartTabBarItem.badgeValue = value
    }
}
