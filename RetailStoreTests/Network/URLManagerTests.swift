//
//  URLManagerTests.swift
//  RetailStoreTests
//
//  Created by Jitendra on 14/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import XCTest
@testable import RetailStore

class URLManagerTests: XCTestCase {

    func testGetURLForEndpoint() {
        
        guard let url = URLManager.getURLForEndpoint(endpoint: .sections) else {
            return XCTFail("Endpoint deliveries returning nil URL")
        }
        XCTAssertNotNil(url)
        
        guard let configuredURL = URL(string: Configuration.url) else {
            return XCTFail("Configured string URL not converting to Foundation URL.")
        }
        XCTAssertNotNil(configuredURL)

        XCTAssertEqual(url.host, configuredURL.host)
        XCTAssertEqual(url.scheme, configuredURL.scheme)
        XCTAssertEqual(url.user, configuredURL.user)
        XCTAssertEqual(url.password, configuredURL.password)
        XCTAssertEqual(url.port, configuredURL.port)
        
        let pathComponents = url.pathComponents
        XCTAssertNotNil(pathComponents)
        XCTAssertEqual(pathComponents.count, 3)
        
        guard let urlComponent = URLComponents(string: url.absoluteString) else {
            return XCTFail("Failed to generate `URLComponent` from `url`.")
        }
        XCTAssertEqual(urlComponent.queryItems?.count, 0)
        
        let pageValue = urlComponent.queryItems?.first(where: {$0.name == "page"})?.value
        XCTAssertNil(pageValue)

        let pageSize = urlComponent.queryItems?.first(where: {$0.name == "pageSize"})?.value
        XCTAssertNil(pageSize)
    }
    
    func testGetURLForEndpointWithPage() {
        
        guard let url = URLManager.getURLForEndpoint(endpoint: .sections, page: 3) else {
            return XCTFail("Endpoint deliveries returning nil URL")
        }
        XCTAssertNotNil(url)

        guard let urlComponent = URLComponents(string: url.absoluteString) else {
            return XCTFail("Failed to generate `URLComponent` from `url`.")
        }
        XCTAssertEqual(urlComponent.queryItems?.count, 2)
        
        let page = urlComponent.queryItems?.first(where: {$0.name == "page"})?.value
        XCTAssertNotNil(page)
        XCTAssertEqual(page, "3")
        
        let pageSize = urlComponent.queryItems?.first(where: {$0.name == "pageSize"})?.value
        XCTAssertEqual(pageSize, "\(Configuration.pageSize)")
    }
}
