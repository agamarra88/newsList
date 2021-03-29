//
//  ArticleSourceRepository.swift
//  
//
//  Created by Arturo Gamarra on 3/28/21.
//

import Foundation
import Combine
import Model

public struct ArticleSourceRepository: ArticleRepository {
    
    // MARK: - Properties
    private var local: ArticleLocalRepository
    private var remote: ArticleNetworkRepository
    
    // MARK: - Constructor
    public init(local: ArticleLocalRepository, remote: ArticleNetworkRepository) {
        self.local = local
        self.remote = remote
    }
    
    // MARK: - 
    public func getArticles(from pagination: Pagination, includeLocal: Bool) -> AnyPublisher<[Article], Error> {
        let remoteSubs = remote.getArticles(from: pagination)
        let localSubs = local.getAll()
        
        let combine = Publishers.CombineLatest(remoteSubs, localSubs)
        return combine.map { (remoteArticles, localArticles) -> [Article] in
            var allArticles = remoteArticles
            if includeLocal {
                allArticles.append(contentsOf: localArticles)
                allArticles.sort { $0.publishDate.compare($1.publishDate) == .orderedDescending }
            }
            return allArticles
        }.eraseToAnyPublisher()
    }
    
    public func store(article: Article) -> AnyPublisher<Article, Error> {
        local.store(article: article)
    }
    
    public func delete(article: Article) -> AnyPublisher<Void, Error> {
        local.delete(article: article)
    }
}
