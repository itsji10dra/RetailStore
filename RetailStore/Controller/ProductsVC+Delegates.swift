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
        
        cell?.addToCartView?.plusAction = { [unowned self] quantity in
            guard let infoObj = self.pagingModel.dataSource(at: indexPath.row) else { return false }
            StoreCartManager.default.addCartItem(infoObj, quantity: quantity)
            self.updateProducts()
            return true
        }
        
        cell?.addToCartView?.minusAction = { [unowned self] quantity in
            guard let infoObj = self.pagingModel.dataSource(at: indexPath.row) else { return false }
            StoreCartManager.default.addCartItem(infoObj, quantity: quantity)
            self.updateProducts()
            return true
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

