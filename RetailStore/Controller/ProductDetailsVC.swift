//
//  ProductDetailsVC.swift
//  RetailStore
//
//  Created by Jitendra on 10/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import UIKit

class ProductDetailsVC: UIViewController {

    internal var productInfo: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = productInfo.title
    }
}
