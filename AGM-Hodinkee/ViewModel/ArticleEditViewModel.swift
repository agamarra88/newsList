//
//  ArticleEditViewModel.swift
//  AGM-Hodinkee
//
//  Created by Arturo Gamarra on 3/29/21.
//

import UIKit
import Combine
import Model

public class ArticleEditViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var article: Article
    @Published var selectedImage: UIImage?
    
    @Published var showValidationError: Bool = false
    @Published var errorMessage: String = "" {
        didSet {
            showValidationError = !errorMessage.isEmpty
        }
    }
    
    private let useCase: ArticleStoreUseCase
    private var cancellable : Set<AnyCancellable> = Set()
    
    // MARK: - Constructors
    init(useCase: ArticleStoreUseCase, article: Article) {
        self.useCase = useCase
        self.article = article
    }
    
    // MARK: - Internal
    func validateForm() -> Bool {
        guard let _ = selectedImage else {
            errorMessage = "You must select an image to save the article"
            return false
        }
        let title = article.title.trimmingCharacters(in: .whitespacesAndNewlines)
        if title.isEmpty {
            errorMessage = "You must indicate a title"
            return false
        }
        
        let content = article.content.trimmingCharacters(in: .whitespacesAndNewlines)
        if content.isEmpty {
            errorMessage = "You must indicate a content"
            return false
        }
        return true
    }
    
    func store(completion: @escaping (Article) -> Void) {
        guard let image = selectedImage else { return }
        
        if article.id == nil {
            article.id = UUID().uuidString
            article.publishDate = Date()
        }
        OperationQueue().addOperation { [self] in
            let data = image.pngData()
            
            OperationQueue.main.addOperation {
                article.imageData = data
                useCase.execute(article: article)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                        if case let .failure(error) = completion {
                            self.errorMessage = error.localizedDescription
                        }
                    } receiveValue: { _ in
                        completion(self.article)
                    }
                    .store(in: &cancellable)
            }
        }
    }
}
