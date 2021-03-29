//
//  ArticleRepository.swift
//  
//
//  Created by Arturo Gamarra on 3/28/21.
//

import Foundation
import Combine

public protocol ArticleRepository {
    
    func getArticles(from pagination: Pagination, includeLocal: Bool) -> AnyPublisher<[Article], Error>
    
    func store(article: Article) -> AnyPublisher<Article, Error>
    
    func delete(article: Article) -> AnyPublisher<Void, Error>
}
