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
    
    internal var plusAction: ((UInt) -> Bool)?
    
    internal var minusAction: ((UInt) -> Bool)?

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

    public func updateQuantity(_ quantity: UInt = 0) {
        quantityLabel.text = String(quantity)
        
        let isHidden = quantity == 0
        minusButton.isHidden = isHidden
        quantityLabel.isHidden = isHidden
    }
    
    // MARK: - IBOutlets Actions
    
    @IBAction func plusAction(_ sender: Any) {
    
        if let currentQuantityText = quantityLabel.text,
            let currentQuantity = UInt(currentQuantityText),
            currentQuantity < Configuration.maxQuantityAllowedInCart {
            
            let newQuantity = currentQuantity + 1

            guard plusAction?(newQuantity) == true else { return }
            
            quantityLabel.text = String(newQuantity)
            
            if newQuantity > 0 {
                updateQuantity(newQuantity)
            }
        }
    }
    
    @IBAction func minusAction(_ sender: Any) {
        
        if let currentQuantityText = quantityLabel.text,
            let currentQuantity = UInt(currentQuantityText),
            currentQuantity > 0 {
            
            let newQuantity = currentQuantity - 1

            guard minusAction?(newQuantity) == true else { return }
            
            quantityLabel.text = String(newQuantity)
            
            if newQuantity == 0 {
                updateQuantity(newQuantity)
            }
        }
    }
}
