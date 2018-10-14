//
//  ProductTests.swift
//  RetailStoreTests
//
//  Created by Jitendra on 14/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import XCTest
@testable import RetailStore

class ProductTests: XCTestCase {
    
    // MARK: - Decoding
    
    func testJSONDecoding() {
        
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "Product", withExtension: "json") else {
            return XCTFail("Unable to load JSON from bundle")
        }
        
        guard let data = try? Data(contentsOf: fileURL) else { return XCTFail("Data conversion failed.") }
        
        do {
            let product = try JSONDecoder().decode(Product.self, from: data)
            XCTAssertEqual(product.id, 1)
            XCTAssertEqual(product.title, "Product Title")
            XCTAssertEqual(product.thumbImage.absoluteString, "https://www.example.com/image.png")
            XCTAssertEqual(product.price, 49.99)
        } catch {
            XCTFail("JSON Decoding for class \(Product.self) failed.")
        }
    }
}
