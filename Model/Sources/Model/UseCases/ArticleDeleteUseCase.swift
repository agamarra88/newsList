//
//  ArticleDeleteUseCase.swift
//  
//
//  Created by Arturo Gamarra on 3/28/21.
//

import Foundation
import Combine

public struct ArticleDeleteUseCase {
    
    private let repo: ArticleRepository
    
    public init(repo: ArticleRepository) {
        self.repo = repo
    }
    
    public func execute(article: Article) -> AnyPublisher<Void, Error> {
        return repo.delete(article: article)
    }
}
