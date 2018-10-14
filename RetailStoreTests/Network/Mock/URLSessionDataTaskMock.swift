//
//  URLSessionDataTaskMock.swift
//  RetailStoreTests
//
//  Created by Jitendra on 14/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import Foundation

class URLSessionDataTaskMock: URLSessionDataTask {
    
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    override func resume() {
        closure()
    }
}
