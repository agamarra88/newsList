//
//  DILocator.swift
//  AGM-Hodinkee
//
//  Created by Arturo Gamarra on 3/28/21.
//

import Model
import DataAccess

public struct DILocator {
    
    // MARK: - Singleton
    public static var shared = DILocator()
    
    // MARK: - Properties
    public var inMemory: Bool = false
    
    // MARK: - ViewModel
    func makeArticleListViewModel() -> ArticleListViewModel {
        return ArticleListViewModel(useCase: makeArticlesGetUseCase(), deleteUseCase: makeArticleDeleteUseCase())
    }
    
    func makeArticleEditViewModel(article: Article) -> ArticleEditViewModel {
        return ArticleEditViewModel(useCase: makeArticleStoreUseCase(), article: article)
    }
    
    // MARK: - UseCases
    func makeArticlesGetUseCase() -> ArticlesGetUseCase {
        return ArticlesGetUseCase(repo: makeArticleRepository())
    }
    
    func makeArticleStoreUseCase() -> ArticleStoreUseCase {
        return ArticleStoreUseCase(repo: makeArticleRepository())
    }
    
    func makeArticleDeleteUseCase() -> ArticleDeleteUseCase {
        return ArticleDeleteUseCase(repo: makeArticleRepository())
    }
    
    // MARK: - Repositories
    func makeArticleRepository() -> ArticleRepository {
        var context = PersistenceManager.shared?.context
        if context == nil {
            PersistenceManager.instance(inMemory: inMemory)
            context = PersistenceManager.shared?.context
        }
        let local = ArticleLocalRepository(context: context!)
        let remote = ArticleNetworkRepository()
        return ArticleSourceRepository(local: local, remote: remote)
    }
    
}
