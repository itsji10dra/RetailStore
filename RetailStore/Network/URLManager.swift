//
//  URLManager.swift
//  RetailStore
//
//  Created by Jitendra on 08/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import Foundation

struct URLManager {
    
    // MARK: - Public Methods
    
    public static func getURLForEndpoint(_ endpoint: EndPoint, page: UInt? = nil, appending parameters: Parameters? = nil) -> URL? {
        
        let url = Configuration.url + endpoint.rawValue
        
        guard var urlComponents = URLComponents(string: url) else { return nil }

        let mandatoryQueryItems = endpoint.getMandatoryQueryItems(appending: parameters ?? [:])
        
        let pagingQueryItems = getPagingQueryItemsWithPage(page)
        
        let allQueryItems = [pagingQueryItems, mandatoryQueryItems].flatMap { $0 }
        
        urlComponents.queryItems = allQueryItems
        
        return urlComponents.url
    }
    
    // MARK: - Private Methods
    
    private static func getPagingQueryItemsWithPage(_ pageNumber: UInt?) -> [URLQueryItem] {
        
        guard let pageNumber = pageNumber else { return [] }
        
        let parameters = ["page"    : "\(pageNumber)",
                          "pageSize": "\(Configuration.pageSize)"]
        
        let queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
    
        return queryItems
    }
}
