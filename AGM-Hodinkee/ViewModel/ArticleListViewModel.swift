//
//  ArticleListViewModel.swift
//  AGM-Hodinkee
//
//  Created by Arturo Gamarra on 3/28/21.
//

import Foundation
import Combine
import Model

public class ArticleListViewModel: ObservableObject {
    
    @Published var articles: [Article] = []
    @Published var showError: Bool = false
    @Published var error: Error? {
        didSet {
            showError = error != nil
        }
    }
    
    private var pagination: Pagination = Pagination(page: 1)
    private var useCase: ArticlesGetUseCase
    private var deleteUseCase: ArticleDeleteUseCase
    private var cancellable : Set<AnyCancellable> = Set()
    
    init(useCase: ArticlesGetUseCase, deleteUseCase: ArticleDeleteUseCase) {
        self.useCase = useCase
        self.deleteUseCase = deleteUseCase
        refresh()
    }
    
    func refresh() {
        pagination.page = 1
        getArticles(from: pagination)
    }
    
    func loadNextPage() {
        pagination.page += 1
        getArticles(from: pagination)
    }
    
    func shouldLoadNextPage(after article: Article) -> Bool {
        guard let last = articles.last else { return true }
        if let id = last.id {
            return id == article.id && last.title == article.title
        } else {
            return last.title == article.title
        }
    }
    
    func delete(in indexes: [Int]) {
        OperationQueue().addOperation { [unowned self] in
            for index in indexes {
                let article = articles[index]
                deleteUseCase.execute(article: article)
                    .receive(on: DispatchQueue.main)
                    .sink { (completion) in
                        if case let .failure(error) = completion {
                            self.error = error
                        }
                    } receiveValue: { [self] element in
                        articles.remove(at: index)
                    }
                    .store(in: &cancellable)
            }
        }
    }
    
    private func getArticles(from page: Pagination) {
        useCase.execute(page: page)
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                if case let .failure(error) = completion {
                    self.error = error
                }
            } receiveValue: { [self] elements in
                if pagination.page == 1 {
                    articles = elements
                } else {
                    articles.append(contentsOf: elements)
                }
            }
            .store(in: &cancellable)
        
    }
}
