//
//  File.swift
//  
//
//  Created by Arturo Gamarra on 3/28/21.
//

import Foundation

public struct Pagination {
    
    // MARK: - Properties
    public var page: Int
    public var pageSize: Int
    
    // MARK: - Constructors
    public init(page: Int, pageSize: Int = 20) {
        self.page = page
        self.pageSize = pageSize
    }
}
