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
    
    struct SectionDisplayInfo {
        
        let id: Int32
        
        let title: String
    }
    
    internal var sectionInfoArray: [SectionDisplayInfo]?
    
    internal let cellIdentifier: String = "SectionCell"
    
    internal var pagingModel: PagingViewModel<Section, SectionDisplayInfo>!
    
    internal let cellHeight: CGFloat = 58

    // MARK: - View Hierarchy

    override func viewDidLoad() {
        super.viewDidLoad()

        title = Configuration.storeName
        tableView.rowHeight = cellHeight
        
        pagingModel = PagingViewModel<Section, SectionDisplayInfo>(endPoint: .sections,
                                                                   transform: { result -> [SectionDisplayInfo] in
            return result.map({ SectionDisplayInfo(id: $0.id, title: $0.title) })
        })
        
        loadSections()
    }
    
    // MARK: - Loader Method
    
    internal func loadSections() {
        
        let loadingInfo = pagingModel.loadMoreData { [weak self] (data, error, page) in
            
            ActivityIndicator.stopAnimating()
            
            DispatchQueue.main.async {
                if let data = data {
                    self?.sectionInfoArray = data
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
        guard let modelsVC = Navigation.getViewController(type: ProductsVC.self,
                                                          identifer: "Products") else { return }
//        modelsVC.sec = info
        navigationController?.pushViewController(modelsVC, animated: true)
    }
}

