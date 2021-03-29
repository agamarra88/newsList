//
//  File.swift
//  
//
//  Created by Arturo Gamarra on 3/28/21.
//

import Model

public struct GetArticlesDTO: Codable {
    
    var status: String
    var totalResults: Int
    var articles: [Article]
    
}
