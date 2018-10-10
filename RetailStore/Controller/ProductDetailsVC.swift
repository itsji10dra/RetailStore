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

    // MARK: - Data

    internal var productInfo: Product!
    
    internal let cellIdentifier: String = "ImageCell"
    
    // MARK: - View Hierarchy

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = productInfo.title
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageCollectionView.flashScrollIndicators()
    }
}
