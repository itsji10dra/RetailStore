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

    @IBOutlet var emptyCartView: UIView!
    
    // MARK: - Data
    
    struct CartDisplayInfo {
        
        let totalPriceValue: Double
        
        let totalPrice: String

        let minimumCartPriceMessage: String
        
        let cartIsEmpty: Bool
    }

    internal let cellIdentifier: String = "CartCell"

    internal let cartViewModel = CartViewModel()
    
    // MARK: - View Hierarchy

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        refreshUI()
    }
    
    // MARK: - IBOutlets Actions
    
    @IBAction func editAction() {
        tableView.setEditing(tableView.isEditing == false, animated: true)
        editBarButton.title = tableView.isEditing ? "Done" : "Edit"
        clearBarButton.isEnabled = tableView.isEditing
    }
    
    @IBAction func clearAllAction(_ sender: Any) {
        clearAllAlert()
    }
    
    @IBAction func checkoutAction() {
        
        let totalPrice = StoreCartManager.default.getTotalPrice()

        if totalPrice < Configuration.minimumCartValue {
            //Show Alert
            return
        }
        
        //Show payment options
    }
    
    // MARK: - Alert

    private func clearAllAlert() {
        let alertController = UIAlertController(title: "Clear Cart",
                                                message: "Are you sure you want to clear your cart items?",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        let clearAction = UIAlertAction(title: "Clear", style: .destructive) { [unowned self] _ in
            StoreCartManager.default.clearCart()
            self.tableView.reloadData()
            self.editAction()
            self.refreshUI()
        }
        alertController.addAction(clearAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    internal func showDeleteAlertForItemAtIndexPath(_ indexPath: IndexPath) {
        
        let name = StoreCartManager.default.getCartItemsAtIndex(indexPath.row)?.title ?? "item"
        
        let alertController = UIAlertController(title: "Delete Item",
                                                message: "Are you sure you want to remove this \(name) from your cart?",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        let clearAction = UIAlertAction(title: "Delete", style: .destructive) { [unowned self] _ in
            StoreCartManager.default.deleteCartItemAt(index: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.refreshUI()
        }
        alertController.addAction(clearAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - UI Methods
    
    internal func refreshUI() {
        cartViewModel.loadData { [weak self] info in
            self?.priceLabel.text = info.totalPrice
            self?.minimumValueLabel.text =  info.minimumCartPriceMessage
            self?.configureEmptyCartUI(info.cartIsEmpty == false)
        }
    }
    
    private func configureEmptyCartUI(_ emptyCart: Bool) {
        
        defer {
            editBarButton.isEnabled = emptyCart
            emptyCartView.isHidden = emptyCart
        }
        
        if emptyCartView.isDescendant(of: view) == false {
            view.addSubview(emptyCartView)
            emptyCartView.alignWithSuperView()
        }
    }
    
    // MARK: - Navigation
    
    internal func pushDetailsScene(with info: CartItem) {
        guard let detailsVC = Navigation.getViewController(type: ProductDetailsVC.self,
                                                           identifer: "ProductDetails") else { return }
        detailsVC.detailsViewModel = ProductDetailsViewModel(product: info)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
