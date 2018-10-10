//
//  ProductDetailsViewModel.swift
//  RetailStore
//
//  Created by Jitendra on 10/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import Foundation

class ProductDetailsViewModel {
    
    // MARK: - Private Properties

    private var dataTask: URLSessionDataTask?
    
    private lazy var networkManager = NetworkManager()

    let productInfo: Product
    
    // MARK: - Initializer
    
    init(product: Product) {
        self.productInfo = product
    }
    
    // MARK: - Public Methods
    
    public func loadDetails(completionHandler: @escaping (ProductDetailsVC.ProductDetailsDisplayModel?) -> Void) {
        
        let parameter = ["productId": "\(productInfo.id)"]
        
        guard let url = URLManager.getURLForEndpoint(endpoint: .productDetail, appending: parameter) else { return }
        
        dataTask = networkManager.dataTaskFromURL(url,
                                                  completion: { (result: Result<Response<ProductDetails>>) in
                                                    
            switch result {
            case .success(let response):
                let productDetail = response.result
                
                let productDetailDisplayModel = ProductDetailsVC.ProductDetailsDisplayModel(title: productDetail.title,
                                                                                            images: productDetail.images,
                                                                                            quantity: 0,
                                                                                            description: productDetail.description,
                                                                                            price: Configuration.currencySymbol + "\(productDetail.price)")
                completionHandler(productDetailDisplayModel)
            
            case .failure( _):
                completionHandler(nil)
            }
            
            print("--------------------------------------------------------------------------------------")
        })
        
        dataTask?.resume()
    }
    
    public func loadStubDetails(completionHandler: @escaping (ProductDetailsVC.ProductDetailsDisplayModel?) -> Void) {

        //Adding delay, so that loading view can be shown.
        DispatchQueue.main.asyncAfter(deadline: .now() + Configuration.stubTimerDelay) { [weak self] in

            guard let response = StubManager.getStubResponse(endpoint: .productDetail,
                                                         parameters: [:],
                                                         type: ProductDetails.self) else { return completionHandler(nil) }
        
            let productDetail = response.result

            let productDetailDisplayModel = ProductDetailsVC.ProductDetailsDisplayModel(title: productDetail.title,
                                                                                        images: productDetail.images,
                                                                                        quantity: 0,
                                                                                        description: productDetail.description,
                                                                                        price: Configuration.currencySymbol + "\(productDetail.price)")

            completionHandler(productDetailDisplayModel)
        }
    }
}
