//
//  ProductsVC.swift
//  RetailStore
//
//  Created by Jitendra on 08/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import UIKit

class ProductsVC: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var loaderView: LoadingView!
    
    // MARK: - Data
    
    struct ProductDisplayInfo {
        
        let title: String
        
        let image: URL
        
        let price: String
    }

    internal var sectionInfo: Section!
    
    internal let cellIdentifier: String = "ProductCell"

    internal var productInfoArray: [ProductDisplayInfo]?

    internal var pagingModel: PagingViewModel<Product, ProductDisplayInfo>!

    internal let cellHeight: CGFloat = 90

    // MARK: - View Hierarchy

    override func viewDidLoad() {
        super.viewDidLoad()

        title = sectionInfo.title
        tableView.rowHeight = cellHeight

        let parameters = ["sectionId": "\(sectionInfo.id)"]
        
        pagingModel = PagingViewModel<Product, ProductDisplayInfo>(endPoint: .products,
                                                                   parameters: parameters,
                                                                   transform: { result -> [ProductDisplayInfo] in
            return result.map {
                ProductDisplayInfo(title: $0.title, image: $0.image, price: Configuration.currencySymbol + "\($0.price)")
            }
        })
        
        loadProducts()
    }
    
    // MARK: - Loader Method
    
    internal func loadProducts() {
        
        let handler: PagingViewModel<Product, ProductDisplayInfo>.PagingDataResult = { [weak self] (data, error, page) in
            
            ActivityIndicator.stopAnimating()
            
            DispatchQueue.main.async {
                if let data = data {
                    self?.productInfoArray = data
                    self?.tableView.reloadData()
                    self?.loaderView.hide()
                } else if let error = error {
                    if page == 0 {
                        self?.showErrorAlert(with: error.localizedDescription)
                    } else {
                        self?.loaderView.showMessage("Error loading data.", animateLoader: false, autoHide: 5.0)
                    }
                }
            }
        }
        
        let loadingInfo = Configuration.useStubData ? pagingModel.loadMoreStubData(handler: handler) : pagingModel.loadMoreData(handler: handler)
        
        if loadingInfo.isLoading {
            if loadingInfo.page == 0 {
                ActivityIndicator.startAnimating()
            } else {
                loaderView.showMessage("Loading...", animateLoader: true)
            }
        } else {
            loaderView.hide()
        }
    }
    
    // MARK: - Alerts
    
    private func showErrorAlert(with message: String) {
        
        let alertController = UIAlertController(title: "Error",
                                                message: message,
                                                preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.loadProducts()
        }
        alertController.addAction(retryAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
