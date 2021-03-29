//
//  ArticleLocal+CoreDataProperties.swift
//  
//
//  Created by Arturo Gamarra on 3/28/21.
//
//

import Foundation
import CoreData


extension ArticleLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleLocal> {
        return NSFetchRequest<ArticleLocal>(entityName: "ArticleLocal")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var creationDate: Date?
    @NSManaged public var picture: ArticleImageLocal?

}
