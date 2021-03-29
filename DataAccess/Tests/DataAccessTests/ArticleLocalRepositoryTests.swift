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

final class ArticleLocalRepositoryTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        PersistenceManager.instance(inMemory: true)
    }
    
    func testStoreRetriveArticles() {
        var article = Article()
        article.id = UUID().uuidString
        article.title = "Test 1"
        article.content = "Test Constent 1"
        article.publishDate = Date()
        
        var storedArticle: Article?
        
        let exp = expectation(description: "Store Article")
        let context = PersistenceManager.shared?.context
        XCTAssertTrue(context != nil)
        
        let repo = ArticleLocalRepository(context: context!)
        repo.store(article: article)
            .flatMap({ _ in  repo.getAll() })
            .sink { completion in
                if case let .failure(error) = completion {
                    XCTAssertNil(error)
                }
                exp.fulfill()
            } receiveValue: { dtos in
                storedArticle = dtos.first
            }
            .store(in: &cancellables)
        waitForExpectations(timeout: 60, handler: nil)
        
        XCTAssertTrue(storedArticle != nil)
        XCTAssertTrue(storedArticle?.id == article.id)
    }
}
