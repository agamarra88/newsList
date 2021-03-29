//
//  File.swift
//  
//
//  Created by Arturo Gamarra on 3/28/21.
//

import XCTest
import Combine
import Model
@testable import DataAccess

final class ArticleDatasourceTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        PersistenceManager.instance(inMemory: true)
    }
    
    func testGetArticles() {
        var articles: [Article] = []
        
        let context = PersistenceManager.shared?.context
        XCTAssertTrue(context != nil)
        
        let local = ArticleLocalRepository(context: context!)
        let remote = ArticleNetworkRepository()
        let source = ArticleSourceRepository(local: local, remote: remote)
        
        let exp = expectation(description: "Get Article")
        source.getArticles(from: Pagination(page: 1), includeLocal: true)
            .sink { completion in
                if case let .failure(error) = completion {
                    XCTAssertNil(error)
                }
                exp.fulfill()
            } receiveValue: { dtos in
                articles = dtos
            }
            .store(in: &cancellables)
        waitForExpectations(timeout: 60, handler: nil)
        
        print(articles)
        XCTAssertTrue(articles.count != 0)
    }
}
