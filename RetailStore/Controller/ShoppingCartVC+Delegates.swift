//
//  ShoppingCartVC+Delegates.swift
//  RetailStore
//
//  Created by Jitendra on 10/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import UIKit

extension ShoppingCartVC: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StoreCartManager.default.getCartItemsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CartCell
        
        guard let item = StoreCartManager.default.getCartItemsAtIndex(indexPath.row) else { return cell ?? UITableViewCell() }

        cell?.titleLabel?.text = item.title
        cell?.priceLabel?.text = Configuration.currencySymbol + " \(item.price)"
//        cell?.imageView?.image = item.thumbImage
        cell?.addToCartView?.updateQuantity(item.quantity)
        
        cell?.addToCartView?.plusAction = { quantity in
            StoreCartManager.default.addCartItem(item, quantity: quantity)
            return true
        }
        
        cell?.addToCartView?.minusAction = { [unowned self] quantity in
            if quantity == 0 {
                self.showDeleteAlertForItemAtIndexPath(indexPath)
                return false
            } else {
                StoreCartManager.default.addCartItem(item, quantity: quantity)
                return true
            }
        }

        return cell ?? UITableViewCell()
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let infoObj = StoreCartManager.default.getCartItemsAtIndex(indexPath.row) else { return }
        pushDetailsScene(with: infoObj)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showDeleteAlertForItemAtIndexPath(indexPath)
        }
    }
}


