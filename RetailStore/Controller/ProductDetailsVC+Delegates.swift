//
//  ProductDetailsVC+Delegates.swift
//  RetailStore
//
//  Created by Jitendra on 10/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import UIKit

extension ProductDetailsVC: UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayModelInfo?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ImagesCell
        
        let url = displayModelInfo?.images[indexPath.row]

//        cell?.imageView?.image
        
        return cell ?? UICollectionViewCell()
    }
}