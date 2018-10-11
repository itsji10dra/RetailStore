//
//  ImageDownloader.swift
//  RetailStore
//
//  Created by Jitendra on 12/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import UIKit
import Foundation

class ImageDownloader: NSObject {
    
    public typealias ImageDownloaderCompletionHandler = ((_ image: UIImage?, _ error: Error?) -> Void)
    
    class ImageFetchLoad {
        var handlers = [ImageDownloaderCompletionHandler?]()
        var responseData = NSMutableData()
        var dataTask: URLSessionDataTask?
    }
    
    // MARK: - Data
    
    public static let shared = ImageDownloader()
    
    private var downloadTimeout: TimeInterval = 15.0
    
    private var session: URLSession!
    
    private var fetchLoads: [URL:ImageFetchLoad] = [:]
    
    // MARK: - Initializer
    
    override init() {
        super.init()
        
        self.session = URLSession(configuration: .ephemeral, delegate: self, delegateQueue: nil)
    }
    
    // MARK: - DeInitializer
    
    deinit {
        session.invalidateAndCancel()
    }
    
    // MARK: - Public Methods
    
    public func downloadImage(with url: URL,
                              completionHandler: ImageDownloaderCompletionHandler? = nil) -> URLSessionDataTask {
        
        func createNewDataTask(from url: URL) -> URLSessionDataTask {
            let request = URLRequest(url: url,
                                     cachePolicy: .reloadIgnoringLocalCacheData,
                                     timeoutInterval: downloadTimeout)
            let dataTask = session.dataTask(with: request)
            return dataTask
        }
        
        let loadObjectForURL = fetchLoads[url] ?? ImageFetchLoad()
        
        loadObjectForURL.handlers.append(completionHandler)
        
        if loadObjectForURL.dataTask == nil {
            let dataTask = createNewDataTask(from: url)
            dataTask.resume()
            loadObjectForURL.dataTask = dataTask
        }
        
        fetchLoads[url] = loadObjectForURL
        
        return loadObjectForURL.dataTask ?? URLSessionDataTask()
    }
    
    // MARK: - Private Methods
    
    private func processImage(for url: URL) {
        
        guard let fetchLoad = fetchLoads[url] else { return }
        
        let data = fetchLoad.responseData
        
        let key = url.absoluteString
        
        var imageCache: [String:UIImage] = [:]
        
        for handler in fetchLoad.handlers {
            
            var image = imageCache[key]
            
            if image == nil,
                let newImage = UIImage(data: data as Data) {
                imageCache[key] = newImage
                image = newImage
            }
            
            handler?(image, nil)
        }
        
        fetchLoads.removeValue(forKey: url)
    }
}

extension ImageDownloader: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        guard let url = dataTask.originalRequest?.url,
            let fetchLoad = fetchLoads[url] else { return }
        
        fetchLoad.responseData.append(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        guard let url = task.originalRequest?.url else { return }
        
        guard error == nil else {
            fetchLoads.removeValue(forKey: url)
            return
        }
        
        processImage(for: url)
    }
}
