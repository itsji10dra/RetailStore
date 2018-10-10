//
//  ShoppingCartVC.swift
//  RetailStore
//
//  Created by Jitendra on 09/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import UIKit

class ShoppingCartVC: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var priceLabel: UILabel!

    @IBOutlet weak var minimumValueLabel: UILabel!

    @IBOutlet weak var checkoutButton: UIButton!

    @IBOutlet weak var editBarButton: UIBarButtonItem!

    @IBOutlet weak var clearBarButton: UIBarButtonItem!

    // MARK: - Data

    internal let cellIdentifier: String = "CartCell"

    // MARK: - View Hierarchy

    override func viewDidLoad() {
        super.viewDidLoad()

        clearBarButton.isEnabled = false
        minimumValueLabel.text =  "Minimum cart value must be $\(Configuration.minimumCartValue)"
    }
    
    // MARK: - IBOutlets Actions
    
    @IBAction func editAction() {
        tableView.setEditing(tableView.isEditing == false, animated: true)
        editBarButton.title = tableView.isEditing ? "Done" : "Edit"
        clearBarButton.isEnabled = tableView.isEditing
    }
    
    @IBAction func clearAllAction(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Clear Cart",
                                                message: "Are you sure you want to clear your cart items?",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alertController.addAction(cancelAction)
        
        let clearAction = UIAlertAction(title: "Clear", style: .destructive) { [unowned self] _ in
            CartManager.default.clearCart()
            self.tableView.reloadData()
            self.editAction()
        }
        alertController.addAction(clearAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    internal func pushDetailsScene(with info: Cartable) {
        guard let detailsVC = Navigation.getViewController(type: ProductDetailsVC.self,
                                                           identifer: "ProductDetails") else { return }
        detailsVC.detailsViewModel = ProductDetailsViewModel(product: info)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
