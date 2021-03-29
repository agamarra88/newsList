//
//  ArticleLocalRepository.swift
//  
//
//  Created by Arturo Gamarra on 3/28/21.
//

import CoreData
import Combine
import Model

public struct ArticleLocalRepository {
    
    // MARK: - Properties
    var context: NSManagedObjectContext
    
    // MARK: - Constructor
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public
    func store(article: Article) -> AnyPublisher<Article, Error> {
        return Future<Article, Error> { promise in
            OperationQueue().addOperation {
                guard let id = article.id else { return }
                 
                let dto = findOrCreate(by: id)
                dto.copy(from: article)
                
                do {
                    try context.save()
                    promise(Result.success(article))
                } catch(let ex) {
                    promise(Result.failure(ex))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func delete(article: Article) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            OperationQueue().addOperation {
                guard let id = article.id else { return }
                
                let dto = findOrCreate(by: id)
                context.delete(dto)
                do {
                    try context.save()
                    promise(Result.success(()))
                } catch(let ex) {
                    promise(Result.failure(ex))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func getAll() -> AnyPublisher<[Article], Error> {
        return Future<[Article], Error> { promise in
            OperationQueue().addOperation {
                let dtos = findAll()
                let articles = dtos.map { $0.toModel }
                promise(Result.success(articles))
            }
        }.eraseToAnyPublisher()
    }
    
    // MARK: - Private
    private func findOrCreate(by id:String) -> ArticleLocal {
        let request = NSFetchRequest<ArticleLocal>(entityName: String(describing: ArticleLocal.self))
        request.predicate = NSPredicate(format: "id = %@", id)
        
        do {
            let result = try context.fetch(request)
            guard let article = result.first else {
                return ArticleLocal(context: context)
            }
            return article
        } catch {
            return ArticleLocal(context: context)
        }
    }
    
    private func findAll() -> [ArticleLocal] {
        let order = NSSortDescriptor(keyPath: \ArticleLocal.creationDate, ascending: false)
        let request = NSFetchRequest<ArticleLocal>(entityName: String(describing: ArticleLocal.self))
        request.sortDescriptors = [order]
        
        let result = try? context.fetch(request)
        return result ?? []
    }
}
