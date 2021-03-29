//
//  RestAPI.swift
//
//
//  Created by Arturo Gamarra on 3/28/21.
//

import XCTest
import Model
import Combine
@testable import DataAccess

final class ArticleNetworkRepositoryTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    func testGetArticles() {
        var articles: [Article] = []
        
        let exp = expectation(description: "Get Articles")
        let repo = ArticleNetworkRepository()
        repo.getArticles(from: Pagination(page: 1))
            .sink { completion in
                if case let .failure(error) = completion {
                    XCTAssertNil(error)
                }
                exp.fulfill()
            } receiveValue: { dto in
                articles = dto
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 60, handler: nil)
        
        XCTAssertTrue(articles.count != 0)
    }
    
    
    static var allTests = [
        ("testExample", testGetArticles),
    ]
}
