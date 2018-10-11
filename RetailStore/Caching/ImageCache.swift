//
//  ImageCache.swift
//  RetailStore
//
//  Created by Jitendra on 12/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import UIKit
import Foundation

class ImageCache {
    
    // MARK: - Data
    
    public static let shared = ImageCache(name: "shared")
    
    private let memoryCache = NSCache<NSString, UIImage>()
    
    var maxMemoryCost: UInt = 0 {
        didSet {
            self.memoryCache.totalCostLimit = Int(maxMemoryCost)
        }
    }
    
    private let imageCost: ((UIImage) -> Int) = { image in
        return Int(image.size.height * image.size.width * image.scale)
    }
    
    private let fileManager = FileManager.default
    
    private var cacheDirPath: URL? {
        return fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
    }
    
    // MARK: - Initializer
    
    public init(name: String) {
        
        let bundleId =  Bundle.main.bundleIdentifier ?? ""
        let cacheName = bundleId + ".\(name)"
        memoryCache.name = cacheName
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(clearMemoryCache),
                                               name: UIApplication.didReceiveMemoryWarningNotification,
                                               object: nil)
    }
    
    // MARK: - DeInitializer
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Public Methods
    
    public func store(_ image: UIImage,
                      forKey key: String,
                      toDisk: Bool = true,
                      completionHandler: (() -> Void)? = nil) {
        
        memoryCache.setObject(image, forKey: key as NSString, cost: imageCost(image))
        
        if toDisk {
            if let path = cacheDirPath?.appendingPathComponent(key).path,
                let data = image.jpegData(compressionQuality: 1.0) ?? image.pngData(),
                fileManager.fileExists(atPath: path) == false {
                if fileManager.createFile(atPath: path, contents: data, attributes: nil) {
//                    print("Cached To Disk: ", key)
                }
            }
        }
        
        if let handler = completionHandler {
            DispatchQueue.main.async {
                handler()
            }
        }
    }
    
    public func removeImage(forKey key: String,
                            completionHandler: (() -> Void)? = nil) {
        
        memoryCache.removeObject(forKey: key as NSString)
        
        if let handler = completionHandler {
            DispatchQueue.main.async {
                handler()
            }
        }
    }
    
    public func retrieve(forKey key: String, consider diskCache: Bool = false) -> UIImage? {
        
        func imageFromDisk() -> UIImage? {
            guard diskCache,
                let path = cacheDirPath?.appendingPathComponent(key).path else { return nil }
            return UIImage(contentsOfFile: path)
        }
        
        return memoryCache.object(forKey: key as NSString) ?? imageFromDisk()
    }
    
    @objc
    public func clearMemoryCache() {
        memoryCache.removeAllObjects()
    }
}
