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
        shouldResetContent(true)
    }
    
    private func shouldResetContent(_ reset: Bool) {
        minusButton.isHidden = reset
        quantityLabel.isHidden = reset
        plusButton.setTitle(reset ? "Add" : "+", for: .normal)
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
                shouldResetContent(false)
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
                shouldResetContent(true)
            }
        }
    }
}
