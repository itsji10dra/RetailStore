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

    // MARK: - Data

    internal let cellIdentifier: String = "CartCell"

    // MARK: - View Hierarchy

    override func viewDidLoad() {
        super.viewDidLoad()

        minimumValueLabel.text =  "Minimum cart value must be $\(Configuration.minimumCartValue)"
    }
    
    // MARK: - IBOutlets Actions
    
    @IBAction func editAction(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        editBarButton.title = tableView.isEditing ? "Done" : "Edit"
    }
    
    // MARK: - Navigation
    
    internal func pushDetailsScene(with info: Product) {
        guard let detailsVC = Navigation.getViewController(type: ProductDetailsVC.self,
                                                           identifer: "ProductDetails") else { return }
        detailsVC.detailsViewModel = ProductDetailsViewModel(product: info)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
