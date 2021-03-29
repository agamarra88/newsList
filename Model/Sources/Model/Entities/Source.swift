//
//  Source.swift
//  
//
//  Created by Arturo Gamarra on 3/28/21.
//

import Foundation

public struct Source: Codable {
    
    // MARK: - Properties
    public let id: String?
    public let name: String
    
    // MARK: - Constructors
    public init(id: String? = nil, name: String = "") {
        self.id = id
        self.name = name
    }
}
