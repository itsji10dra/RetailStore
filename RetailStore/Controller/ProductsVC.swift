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
    
    @IBOutlet var noProductsView: UIView!
    
    // MARK: - Data
    
    struct ProductDisplayInfo {
        
        let title: String
        
        let image: URL
        
        let price: String
        
        let quantity: UInt
    }

    internal var sectionInfo: Section!
    
    internal let cellIdentifier: String = "ProductCell"

    internal var productInfoArray: [ProductDisplayInfo]?

    internal var pagingModel: PagingViewModel<Product, ProductDisplayInfo>!

    // MARK: - View Hierarchy

    override func viewDidLoad() {
        super.viewDidLoad()

        title = sectionInfo.title
        
        let parameters = ["sectionId": "\(sectionInfo.id)"]
        
        pagingModel = PagingViewModel<Product, ProductDisplayInfo>(endPoint: .products,
                                                                   parameters: parameters,
                                                                   transform: { result -> [ProductDisplayInfo] in
            return result.map {
                let quantity = StoreCartManager.default.quantityForItem($0)
                return ProductDisplayInfo(title: $0.title,
                                          image: $0.thumbImage,
                                          price: Configuration.currencySymbol + "\($0.price)",
                                          quantity: quantity)
            }
        })
        
        loadProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateProducts()
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
                    self?.showNoProductsViewIfNeeded()
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
                ActivityIndicator.startAnimating { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
            } else {
                loaderView.showMessage("Loading...", animateLoader: true)
            }
        } else {
            loaderView.hide()
        }
    }
    
    internal func updateProducts() {
        pagingModel.updateResult { [weak self] data in
            self?.productInfoArray = data
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - UI
    
    private func showNoProductsViewIfNeeded() {
        guard productInfoArray?.isEmpty == true else { return }
        view.addSubview(noProductsView)
        noProductsView.alignWithSuperView()
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
    
    // MARK: - Navigation
    
    internal func pushDetailsScene(with info: Product) {
        guard let detailsVC = Navigation.getViewController(type: ProductDetailsVC.self,
                                                           identifer: "ProductDetails") else { return }
        detailsVC.detailsViewModel = ProductDetailsViewModel(product: info)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
