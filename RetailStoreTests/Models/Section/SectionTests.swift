//
//  SectionTests.swift
//  RetailStoreTests
//
//  Created by Jitendra on 14/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import XCTest
@testable import RetailStore

class SectionTests: XCTestCase {
    
    // MARK: - Decoding
    
    func testJSONDecoding() {
        
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "Section", withExtension: "json") else {
            return XCTFail("Unable to load JSON from bundle")
        }
        
        guard let data = try? Data(contentsOf: fileURL) else { return XCTFail("Data conversion failed.") }
        
        do {
            let section = try JSONDecoder().decode(Section.self, from: data)
            XCTAssertEqual(section.id, 1)
            XCTAssertEqual(section.title, "My Section Title")
            XCTAssertEqual(section.identifier, "My Section Identifier")
        } catch {
            XCTFail("JSON Decoding for class \(Section.self) failed.")
        }
    }
}
