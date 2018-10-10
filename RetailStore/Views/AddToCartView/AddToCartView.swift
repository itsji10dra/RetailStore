//
//  AddToCartView.swift
//  RetailStore
//
//  Created by Jitendra on 10/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import UIKit

class AddToCartView: UIView {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var quantityLabel: UILabel!
    
    @IBOutlet private weak var plusButton: UIButton!
    
    @IBOutlet private weak var minusButton: UIButton!
    
    // MARK: - Data Closure
    
    internal var plusAction: (() -> Void)?
    
    internal var minusAction: (() -> Void)?

    // MARK: - View
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        loadContentView()
        updateQuantity()
    }
    
    // MARK: - Public Methods

    private func updateQuantity(_ quantity: Int = 0) {
        quantityLabel.text = String(quantity)
        
        let isHidden = quantity == 0
        minusButton.isHidden = isHidden
        quantityLabel.isHidden = isHidden
    }
    
    // MARK: - IBOutlets Actions
    
    @IBAction func plusAction(_ sender: Any) {
    
        if let currentQuantityText = quantityLabel.text,
            let currentQuantity = Int(currentQuantityText),
            currentQuantity < Configuration.maxQuantityAllowedInCart {
            
            let newQuantity = currentQuantity + 1
            quantityLabel.text = String(newQuantity)
            plusAction?()
            
            if newQuantity > 0 {
                updateQuantity(newQuantity)
            }
        }
    }
    
    @IBAction func minusAction(_ sender: Any) {
        
        if let currentQuantityText = quantityLabel.text,
            let currentQuantity = Int(currentQuantityText),
            currentQuantity > 0 {
            
            let newQuantity = currentQuantity - 1
            quantityLabel.text = String(newQuantity)
            minusAction?()
            
            if newQuantity == 0 {
                updateQuantity(newQuantity)
            }
        }
    }
}
