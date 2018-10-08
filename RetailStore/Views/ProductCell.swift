//
//  ProductCell.swift
//  RetailStore
//
//  Created by Jitendra on 08/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel?
    
    @IBOutlet weak var thumbImageView: UIImageView?
    
    @IBOutlet weak var priceLabel: UILabel?

    // MARK: - View

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
