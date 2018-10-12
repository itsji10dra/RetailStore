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
        cell?.addToCartView?.updateQuantity(item.quantity)
        cell?.thumbImageView?.setImage(with: item.thumbImage, placeholder: #imageLiteral(resourceName: "placeholder-small"), useDiskCache: true)

        func adjustQuantity(_ quantity: UInt) -> Bool {
            let updatedItem = CartItem(item: item, quantity: quantity)
            StoreCartManager.default.addCartItem(updatedItem)
            return true
        }

        cell?.addToCartView?.plusAction = { quantity in
            return adjustQuantity(quantity)
        }
        
        cell?.addToCartView?.minusAction = { [unowned self] quantity in
            if quantity == 0 {
                self.showDeleteAlertForItemAtIndexPath(indexPath)
                return false
            } else {
                return adjustQuantity(quantity)
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


