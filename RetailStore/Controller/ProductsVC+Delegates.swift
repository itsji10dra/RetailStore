//
//  ProductsVC+Delegates.swift
//  RetailStore
//
//  Created by Jitendra on 08/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import UIKit

extension ProductsVC: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.height
        
        if bottomEdge >= scrollView.contentSize.height {    //We reached bottom
            loadProducts()
        }
    }
}

extension ProductsVC: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productInfoArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ProductCell
        
        let infoObj = productInfoArray?[indexPath.row]
        
        cell?.titleLabel?.text = infoObj?.title
        cell?.priceLabel?.text = infoObj?.price
        cell?.addToCartView?.updateQuantity(infoObj?.quantity ?? 0)

        if let url = infoObj?.image {
            cell?.thumbImageView?.setImage(with: url, placeholder: #imageLiteral(resourceName: "placeholder-small"), useDiskCache: true)
        }
        
        func adjustCartItemAtIndex(_ index: Int, quantity: UInt) -> Bool {
            guard let info = pagingModel.dataSource(at: index) else { return false }
            let cartItem = CartItem(item: info, quantity: quantity)
            StoreCartManager.default.addCartItem(cartItem)
            updateProducts()
            return true
        }
        
        cell?.addToCartView?.plusAction = { quantity in
            return adjustCartItemAtIndex(indexPath.row, quantity: quantity)
        }
        
        cell?.addToCartView?.minusAction = { quantity in
            return adjustCartItemAtIndex(indexPath.row, quantity: quantity)
        }

        return cell ?? UITableViewCell()
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let infoObj = pagingModel.dataSource(at: indexPath.row) else { return }
        pushDetailsScene(with: infoObj)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

