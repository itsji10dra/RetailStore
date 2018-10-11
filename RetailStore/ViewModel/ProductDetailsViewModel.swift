//
//  ProductDetailsViewModel.swift
//  RetailStore
//
//  Created by Jitendra on 10/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import Foundation

class ProductDetailsViewModel {
    
    typealias ProductDetailsResult = ((_ data: ProductDetailsVC.ProductDetailsDisplayInfo?, _ error: Error?) -> Void)

    // MARK: - Private Properties

    private var dataTask: URLSessionDataTask?
    
    private lazy var networkManager = NetworkManager()

    internal let product: Cartable
    
    // MARK: - Initializer
    
    public init(product: Cartable) {
        self.product = product
    }
    
    // MARK: - Public Methods
    
    public func loadDetails(completionHandler: @escaping ProductDetailsResult) {
        
        let parameter = ["productId": "\(product.id)"]
        
        guard let url = URLManager.getURLForEndpoint(endpoint: .productDetail, appending: parameter) else { return }
        
        dataTask = networkManager.dataTaskFromURL(url,
                                                  completion: { (result: Result<Response<ProductDetails>>) in
                                                    
            switch result {
            case .success(let response):
                let productDetail = response.result
                
                let quantity = CartManager.default.quantityForItem(productDetail)

                let productDetailDisplayModel = ProductDetailsVC.ProductDetailsDisplayInfo(title: productDetail.title,
                                                                                           images: productDetail.images,
                                                                                           quantity: quantity,
                                                                                           description: productDetail.description,
                                                                                           price: Configuration.currencySymbol + "\(productDetail.price)")
                completionHandler(productDetailDisplayModel, nil)
            
            case .failure(let error):
                completionHandler(nil, error)
            }
        })
        
        dataTask?.resume()
    }
    
    public func loadStubDetails(completionHandler: @escaping ProductDetailsResult) {

        //Adding delay, so that loading view can be shown.
        DispatchQueue.main.asyncAfter(deadline: .now() + Configuration.stubTimerDelay) { 

            guard let response = StubManager.getStubResponse(endpoint: .productDetail,
                                                             parameters: [:],
                                                             type: ProductDetails.self) else { return completionHandler(nil, nil) }
        
            let productDetail = response.result

            let quantity = CartManager.default.quantityForItem(productDetail)

            let productDetailDisplayModel = ProductDetailsVC.ProductDetailsDisplayInfo(title: productDetail.title,
                                                                                       images: productDetail.images,
                                                                                       quantity: quantity,
                                                                                       description: productDetail.description,
                                                                                       price: Configuration.currencySymbol + "\(productDetail.price)")
            completionHandler(productDetailDisplayModel, nil)
        }
    }
}
