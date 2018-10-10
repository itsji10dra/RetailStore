//
//  ProductDetailsVC.swift
//  RetailStore
//
//  Created by Jitendra on 10/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import UIKit

class ProductDetailsVC: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var addToCartView: AddToCartView!
    
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var priceLabel: UILabel!

    // MARK: - Data

    struct ProductDetailsDisplayInfo {
        
        let title: String
        
        let images: [URL]
        
        let quantity: Int
        
        let description: String
        
        let price: String
    }
    
    internal let cellIdentifier: String = "ImageCell"
    
    internal var detailsViewModel: ProductDetailsViewModel!
    
    internal var displayModelInfo: ProductDetailsDisplayInfo? {
        didSet {
            refreshUI()
        }
    }
    
    // MARK: - View Hierarchy

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDetails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageCollectionView.flashScrollIndicators()
    }
    
    // MARK: - Private Methods
    
    private func loadDetails() {
        
        ActivityIndicator.startAnimating { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let handler: ProductDetailsViewModel.ProductDetailsResult = { [weak self] (displayModel, error) in
            
            ActivityIndicator.stopAnimating()
            DispatchQueue.main.async {
                if let model = displayModel {
                    self?.displayModelInfo = model
                } else {
                    let message = error?.localizedDescription ?? "Unable to fetch details."
                    self?.showErrorAlert(with: message)
                }
            }
        }
        
        Configuration.useStubData ? detailsViewModel.loadStubDetails(completionHandler: handler) : detailsViewModel.loadDetails(completionHandler: handler)
    }
    
    private func refreshUI() {
        
        guard let info = displayModelInfo else { return }
        
        navigationItem.title = info.title
        imageCollectionView.reloadData()
        addToCartView.updateQuantity(info.quantity)
        descriptionLabel.text = info.description
        priceLabel.text = info.price
    }
    
    // MARK: - Alerts
    
    private func showErrorAlert(with message: String) {
        
        let alertController = UIAlertController(title: "Error",
                                                message: message,
                                                preferredStyle: .alert)
        
        let backAction = UIAlertAction(title: "Back", style: .destructive) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(backAction)
        
        let retryAction = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.loadDetails()
        }
        alertController.addAction(retryAction)

        present(alertController, animated: true, completion: nil)
    }
}
