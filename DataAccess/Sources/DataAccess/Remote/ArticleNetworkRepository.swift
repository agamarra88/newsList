//
//  ArticleNetworkRepository.swift
//  
//
//  Created by Arturo Gamarra on 3/28/21.
//

import Foundation
import Combine
import Model

public struct ArticleNetworkRepository: RestAPI {
    
    public init() { }
    
    public func getArticles(from pagination: Pagination) -> AnyPublisher<[Article], Error> {
        var url = "\(Constants.BASE_URL)everything?q=watches&apiKey=\(Constants.API_KEY)&pagesize=\(pagination.pageSize)&sortBy=publishedAt"
        if pagination.page > 1 {
            url += "&page=\(pagination.page)"
        }
        return callService(url: url, verb: .get).map { (dto:GetArticlesDTO) -> [Article] in
            return dto.articles
        }.eraseToAnyPublisher()
    }
}
