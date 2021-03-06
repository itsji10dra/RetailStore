//
//  StubManager.swift
//  RetailStore
//
//  Created by Jitendra on 08/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import Foundation

struct StubManager {
    
    static func getStubResponse<T: Decodable>(endpoint: EndPoint,
                                              page: UInt = 0,
                                              parameters: Parameters,
                                              type: T.Type) -> Response<T>? {
        let fileName: String
        
        switch endpoint {
        case .sections:
            fileName = "Section"
        case .products:
            let sectionId = parameters["sectionId"] ?? ""
            fileName = "Product-SectionId" + sectionId + "-Page" + "\(page)"
        case .productDetail:
            let productId = parameters["productId"] ?? ""
            fileName = "ProductDetails-Id" + "\(productId)"
        }
        
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "json") else { return nil }
        
        guard let data = try? Data(contentsOf: fileURL) else { return nil }

        let response = try? JSONDecoder().decode(Response<T>.self, from: data)

        return response
    }
}
