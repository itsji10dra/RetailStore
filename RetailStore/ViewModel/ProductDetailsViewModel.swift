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

    internal let product: Sellable
    
    // MARK: - Initializer
    
    public init(product: Sellable) {
        self.product = product
    }
    
    // MARK: - Public Methods
    
    public func loadDetails(completionHandler: @escaping ProductDetailsResult) {
        
        let parameter = ["productId": "\(product.id)"]
        
        guard let url = URLManager.getURLForEndpoint(endpoint: .productDetail, appending: parameter) else { return }
        
        dataTask = networkManager.dataTaskFromURL(url,
                                                  completion: { [weak self] (result: Result<Response<ProductDetails>>) in
                                                    
            switch result {
            case .success(let response):
                let productDetail = response.result
                
                let productDetailDisplayModel = self?.transform(productDetail: productDetail)
                
                completionHandler(productDetailDisplayModel, nil)
            
            case .failure(let error):
                completionHandler(nil, error)
            }
        })
        
        dataTask?.resume()
    }
    
    public func loadStubDetails(completionHandler: @escaping ProductDetailsResult) {

        let parameter = ["productId": "\(product.id)"]

        //Adding delay, so that loading view can be shown.
        DispatchQueue.main.asyncAfter(deadline: .now() + Configuration.stubTimerDelay) { [weak self] in

            guard let response = StubManager.getStubResponse(endpoint: .productDetail,
                                                             parameters: parameter,
                                                             type: ProductDetails.self) else { return completionHandler(nil, nil) }
        
            let productDetail = response.result

            let productDetailDisplayModel = self?.transform(productDetail: productDetail)
            
            completionHandler(productDetailDisplayModel, nil)
        }
    }
    
    // MARK: - Private Methods (Data-Binding)
    
    private func transform(productDetail: ProductDetails) -> ProductDetailsVC.ProductDetailsDisplayInfo {
        
        let quantity = StoreCartManager.default.quantityForItem(productDetail)
        
        let productDetailDisplayModel = ProductDetailsVC.ProductDetailsDisplayInfo(title: productDetail.title,
                                                                                   images: productDetail.images,
                                                                                   quantity: quantity,
                                                                                   description: productDetail.description,
                                                                                   price: Configuration.defaultCurrency + " \(productDetail.price)")
        
        return productDetailDisplayModel
    }
}
