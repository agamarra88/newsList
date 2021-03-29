//
//  ArticleImageLocal+CoreDataProperties.swift
//  
//
//  Created by Arturo Gamarra on 3/28/21.
//
//

import Foundation
import CoreData


extension ArticleImageLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleImageLocal> {
        return NSFetchRequest<ArticleImageLocal>(entityName: "ArticleImageLocal")
    }

    @NSManaged public var image: Data?
    @NSManaged public var article: ArticleLocal?

}
