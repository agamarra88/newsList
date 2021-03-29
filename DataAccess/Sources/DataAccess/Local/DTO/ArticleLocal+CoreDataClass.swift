//
//  ArticleLocal+CoreDataClass.swift
//  
//
//  Created by Arturo Gamarra on 3/28/21.
//
//

import Foundation
import CoreData
import Model

@objc(ArticleLocal)
public class ArticleLocal: NSManagedObject {
    
    var toModel: Article {
        var article = Article()
        article.id = id ?? ""
        article.title = title ?? ""
        article.content = content ?? ""
        article.publishDate = creationDate ?? Date()
        article.imageData = picture?.image
        return article
    }

    func copy(from article:Article) {
        id = article.id
        title = article.title
        content = article.content
        creationDate = article.publishDate
    
        if picture  == nil {
            picture = ArticleImageLocal(context: managedObjectContext!)
        }
        picture?.image = article.imageData
    }
    
    
}
