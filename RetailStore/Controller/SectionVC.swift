//
//  SectionVC.swift
//  RetailStore
//
//  Created by Jitendra on 08/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import UIKit

class SectionVC: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var loaderView: LoadingView!
    
    // MARK: - Data
    
    internal var sectionArray: [String]?
    
    internal let cellIdentifier: String = "SectionCell"
    
    internal var pagingModel: PagingViewModel<Section, String>!
    
    internal let cellHeight: CGFloat = 58

    // MARK: - View Hierarchy

    override func viewDidLoad() {
        super.viewDidLoad()

        title = Configuration.storeName
        tableView.rowHeight = cellHeight
        
        pagingModel = PagingViewModel<Section, String>(endPoint: .sections,
                                                                   transform: { result -> [String] in
            return result.map { $0.title }
        })
        
        loadSections()
    }
    
    // MARK: - Loader Method
    
    internal func loadSections() {
        
        let handler: PagingViewModel<Section, String>.PagingDataResult = { [weak self] (data, error, page) in

            ActivityIndicator.stopAnimating()
            
            DispatchQueue.main.async {
                if let data = data {
                    self?.sectionArray = data
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
            self?.loadSections()
        }
        alertController.addAction(retryAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    internal func pushModelsScene(with info: Section) {
        guard let productsVC = Navigation.getViewController(type: ProductsVC.self,
                                                            identifer: "Products") else { return }
        productsVC.sectionInfo = info
        navigationController?.pushViewController(productsVC, animated: true)
    }
}

