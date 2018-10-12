//
//  PagingViewModel.swift
//  RetailStore
//
//  Created by Jitendra on 08/10/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import Foundation

///
/// T: Expected array model from server
/// E: Desired array model object
///

class PagingViewModel<T, E> where T:Decodable {
    
    typealias PagingDataResult = ((_ data: [E]?, _ error: Error?, _ page: UInt) -> Void)
    
    // MARK: - Private Properties
    
    private lazy var receivedDataSource: [T] = []

    private lazy var dataSource: [E] = []
    
    private var pageInfo: PageInfo = (currentPage: -1, totalPages: 0)
    
    private var dataTask: URLSessionDataTask?
    
    private lazy var networkManager = NetworkManager()
    
    private var failedTaskCount: Int = 0
    
    private var totalRequestMade: Int {
        return dataTask?.taskIdentifier ?? 0
    }

    // MARK: - Public Properties
    
    private let transform: (([T]) -> [E])
    
    private let endPoint: EndPoint
    
    private let parameters: Parameters?
    
    // MARK: - Initializer
    
    init(endPoint: EndPoint, parameters: Parameters? = nil, transform block: @escaping (([T]) -> [E])) {
        self.endPoint = endPoint
        self.parameters = parameters
        self.transform = block
    }
    
    // MARK: - De-Initializer
    
    deinit {
        dataTask?.cancel()
    }
    
    // MARK: - Public Methods
    
    @discardableResult
    public func loadMoreStubData(handler: @escaping PagingDataResult) -> (isLoading: Bool, page: Int) {
        
        let nextPage = pageInfo.currentPage + 1

        guard (nextPage == 0 ||       //Just load, coz it's first page.
                nextPage < pageInfo.totalPages) else { return (false, nextPage) }   //Load, only if next page is available.
        
        //Adding delay, so that loading view can be shown.
        DispatchQueue.main.asyncAfter(deadline: .now() + Configuration.stubTimerDelay) { [weak self] in
            self?.loadStubData(page: UInt(nextPage), completionHandler: handler)
        }
        
        return (true, nextPage)
    }
    
    @discardableResult
    public func loadMoreData(handler: @escaping PagingDataResult) -> (isLoading: Bool, page: Int) {
        
        let nextPage = pageInfo.currentPage + 1
        
        guard dataTask?.state != .running else { return (true, nextPage) } //Do not load, if last data task is already in progress.
        
        let totalSuccessfullRequest = totalRequestMade - failedTaskCount
        
        guard totalSuccessfullRequest == Int(nextPage) &&   //Checking right track.
            (nextPage == 0 ||       //Just load, coz it's first page.
                nextPage < pageInfo.totalPages) else { return (false, nextPage) }   //Load, only if next page is available.
        
        loadData(page: UInt(nextPage), completionHandler: handler)
        
        return (true, nextPage)
    }
    
    public func dataSource(at index: Int) -> T? {        
        return index < receivedDataSource.count ? receivedDataSource[index] : nil
    }
    
    public func clearDataSource() {
        receivedDataSource.removeAll()
        dataSource.removeAll()
    }
    
    public func updateResult(_ handler: (([E]) -> Void)) {
        handler(transform(receivedDataSource))
    }
    
    // MARK: - Private Methods
    
    private func loadData(page number: UInt = 0, completionHandler: @escaping PagingDataResult) {
        
        print("Loading Page:", number, " ↔️ Endpoint:", endPoint.rawValue, " ↔️ Parameters: ", parameters ?? "None")
        
        guard let url = URLManager.getURLForEndpoint(endpoint: endPoint, page: number, appending: parameters) else { return }
        
        dataTask = networkManager.dataTaskFromURL(url,
                                                  completion: { [weak self] (result: Result<Response<[T]>>) in
                                                    
            switch result {
            case .success(let response):
                print(" • Page:", number, " success")
                
                let page = response.page
                
                let totalPages = response.totalPageCount
                
                self?.pageInfo = (currentPage: Int(page), totalPages: totalPages)
                
                let responseData = response.result
                
                guard let data = self?.transform(responseData) else { return completionHandler([], nil, page) }
                
                self?.receivedDataSource.append(contentsOf: responseData)

                self?.dataSource.append(contentsOf: data)
                
                completionHandler(self?.dataSource, nil, UInt(page))
                
            case .failure(let error):
                print(" • Page:", number, " failed. Reason: ", error.localizedDescription)
                self?.failedTaskCount += 1
                completionHandler(nil, error, number)
            }
            
            print("--------------------------------------------------------------------------------------")
        })
        
        dataTask?.resume()
    }
    
    private func loadStubData(page number: UInt = 0, completionHandler: @escaping PagingDataResult) {

        guard let response = StubManager.getStubResponse(endpoint: endPoint,
                                                         page: number,
                                                         parameters: parameters ?? [:],
                                                         type: [T].self) else { return completionHandler([], nil, number) }
        
        let page = response.page
        
        let totalPages = response.totalPageCount
        
        self.pageInfo = (currentPage: Int(page), totalPages: totalPages)
        
        let responseData = response.result
        
        let data = self.transform(responseData)
        
        self.receivedDataSource.append(contentsOf: responseData)
        
        self.dataSource.append(contentsOf: data)
        
        completionHandler(self.dataSource, nil, UInt(page))
    }
}
