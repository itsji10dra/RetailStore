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

    struct ProductDetailsDisplayModel {
        
        let title: String
        
        let images: [URL]
        
        let quantity: Int
        
        let description: String
        
        let price: String
    }
    
    internal let cellIdentifier: String = "ImageCell"
    
    internal var detailsViewModel: ProductDetailsViewModel!
    
    internal var displayModelInfo: ProductDetailsDisplayModel? {
        didSet {
            DispatchQueue.main.async { [weak self] in self?.refreshUI() }
        }
    }
    
    // MARK: - View Hierarchy

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ActivityIndicator.startAnimating { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let handler: ((ProductDetailsDisplayModel?) -> Void) = { displayModel in
            
            ActivityIndicator.stopAnimating()
            
            if let model = displayModel {
                self.displayModelInfo = model
            } else {
                //Show Error
            }
        }
        
        Configuration.useStubData ? detailsViewModel.loadStubDetails(completionHandler: handler) : detailsViewModel.loadDetails(completionHandler: handler)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageCollectionView.flashScrollIndicators()
    }
    
    // MARK: - Private Methods
    
    private func refreshUI() {
        
        guard let info = displayModelInfo else { return }
        
        navigationItem.title = info.title
        imageCollectionView.reloadData()
        addToCartView.updateQuantity(info.quantity)
        descriptionLabel.text = info.description
        priceLabel.text = info.price
    }
}
