//
//  ProductDetailsTests.swift
//  RetailStoreTests
//
//  Created by Jitendra on 14/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import XCTest
@testable import RetailStore

class ProductDetailsTests: XCTestCase {
    
    // MARK: - Decoding
    
    func testJSONDecoding() {
        
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "ProductDetails", withExtension: "json") else {
            return XCTFail("Unable to load JSON from bundle")
        }
        
        guard let data = try? Data(contentsOf: fileURL) else { return XCTFail("Data conversion failed.") }
        
        do {
            let productDetails = try JSONDecoder().decode(ProductDetails.self, from: data)
            XCTAssertEqual(productDetails.id, 1)
            XCTAssertEqual(productDetails.title, "Product Title")
            XCTAssertEqual(productDetails.thumbImage.absoluteString, "https://www.example.com/image.png")
            XCTAssertEqual(productDetails.price, 49.99)
            XCTAssertEqual(productDetails.images.count, 5)
            XCTAssertEqual(productDetails.images.first?.absoluteString, "https://www.example.com/big-image-1.png")
            XCTAssertEqual(productDetails.images.last?.absoluteString, "https://www.example.com/big-image-5.png")
            XCTAssertEqual(productDetails.description, "Lorem ipsum dolor sit amet.")
        } catch {
            XCTFail("sJSON Decoding for class \(ProductDetails.self) failed.")
        }
    }
}
