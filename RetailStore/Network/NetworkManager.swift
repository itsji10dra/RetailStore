//
//  NetworkManager.swift
//  RetailStore
//
//  Created by Jitendra on 08/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

class NetworkManager {

    // MARK: - Properties

    private var session: URLSession!
    
    // MARK: - Initializer

    init() {
        session = URLSession(configuration: .ephemeral)
    }
    
    deinit {
        cancelAllTask()
    }
    
    // MARK: - Public Methods

    public func dataTaskFromURL<T: Decodable>(_ url: URL, completion: @escaping ((Result<T>) -> Void)) -> URLSessionDataTask {
                
        return session.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if error == nil,
                let data = data {
                do {
                    let response = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(response))
                } catch let parsingError {
                    completion(.failure(parsingError))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        })
    }
    
    public func cancelAllTask() {
        session.invalidateAndCancel()
    }
}
