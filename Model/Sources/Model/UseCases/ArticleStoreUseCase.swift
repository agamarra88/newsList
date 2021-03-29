//
//  ArticleStoreUseCase.swift
//  
//
//  Created by Arturo Gamarra on 3/28/21.
//

import Foundation
import Combine

public struct ArticleStoreUseCase {
    
    private let repo: ArticleRepository
    
    public init(repo: ArticleRepository) {
        self.repo = repo
    }
    
    public func execute(article: Article) -> AnyPublisher<Article, Error> {
        return repo.store(article: article)
    }
}
