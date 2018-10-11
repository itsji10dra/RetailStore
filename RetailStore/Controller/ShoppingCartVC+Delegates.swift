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
        return CartManager.default.getCartItemsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CartCell
        
        guard let item = CartManager.default.getCartItemsAtIndex(indexPath.row) else { return cell ?? UITableViewCell() }

        cell?.titleLabel?.text = item.title
        cell?.priceLabel?.text = "\(item.price)"
//        cell?.imageView?.image = item.thumbImage
        cell?.addToCartView?.updateQuantity(item.quantity)
        
        cell?.addToCartView?.plusAction = { quantity in
            CartManager.default.addCartItem(item, quantity: quantity)
            return true
        }
        
        cell?.addToCartView?.minusAction = { quantity in
            if quantity == 0 {
                self.showDeleteAlertForItemAtIndex(indexPath.row)
                return false
            } else {
                CartManager.default.addCartItem(item, quantity: quantity)
                return true
            }
        }

        return cell ?? UITableViewCell()
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let infoObj = CartManager.default.getCartItemsAtIndex(indexPath.row) else { return }
        pushDetailsScene(with: infoObj)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CartManager.default.deleteCartItemAt(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}


