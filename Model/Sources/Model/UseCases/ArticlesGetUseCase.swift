//
//  GetArticlesUseCase.swift
//  
//
//  Created by Arturo Gamarra on 3/28/21.
//

import Foundation
import Combine

public struct ArticlesGetUseCase {
    
    private let repo: ArticleRepository
    
    public init(repo: ArticleRepository) {
        self.repo = repo
    }
    
    public func execute(page: Pagination) -> AnyPublisher<[Article], Error> {
        let includeLocal = page.page <= 1
        return repo.getArticles(from: page, includeLocal: includeLocal)
    }
    
}
