//
//  Article.swift
//
//
//  Created by Arturo Gamarra on 3/28/21.
//

import Foundation

public struct Article: Codable {
    
    // MARK: - Codingkeys
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case author = "author"
        case title = "title"
        case detail = "description"
        case content = "content"
        case urlString = "url"
        case imageUrlString = "urlToImage"
        case publishDate = "publishedAt"
        case source = "source"
        case imageData = "imageData"
    }

    // MARK: - Properties
    public var id: String?
    public var author: String?
    public var title: String
    public var detail: String
    public var content: String
    public var urlString: String
    public var imageUrlString: String?
    public var publishDate: Date
    public var source: Source
    public var imageData: Data?
    
    public var url: URL? {
        return URL(string: urlString)
    }
    
    public var imageURL: URL? {
        guard let url = imageUrlString else { return nil }
        return URL(string: url)
    }
    
    public var mediumDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: publishDate)
    }
    
    public var hasImage: Bool {
        if let _ = imageData {
            return true
        }
        if let _ = imageURL {
            return true
        }
        return false
    }
 
    // MARK: - Constructors
    public init(author: String? = nil,
                title: String = "",
                detail: String = "",
                content: String = "",
                urlString: String = "",
                imageUrlString: String = "",
                publishDate: Date = Date(),
                source: Source = Source()) {
        self.author = author
        self.title = title
        self.detail = detail
        self.content = content
        self.urlString = urlString
        self.imageUrlString = imageUrlString
        self.publishDate = publishDate
        self.source = source
    }
}
