//
//  UIImageView+Extension.swift
//  RetailStore
//
//  Created by Jitendra on 12/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import UIKit
import Foundation

private var kURLKey: Void?

extension UIImageView {
    
    // MARK: - Private
    
    private var imageURL: URL? {
        set { objc_setAssociatedObject(self, &kURLKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
        get { return objc_getAssociatedObject(self, &kURLKey) as? URL }
    }
        
    // MARK: - Public
    
    public func setImage(with url: URL, placeholder: UIImage? = nil, useDiskCache diskCache: Bool = false) {
        
        self.imageURL = url
        self.image = placeholder
        
        ImageDownloadCacheManager.shared.downloadAndCacheImage(with: url, consider: diskCache) { [weak self] (image, url) in
            
            DispatchQueue.main.async {
                
                guard let strongSelf = self, url == strongSelf.imageURL else { return }
                
                strongSelf.image = image
            }
        }
    }
}
