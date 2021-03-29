//
//  RestAPI.swift
//  
//
//  Created by Arturo Gamarra on 3/28/21.
//

import Foundation
import Alamofire
import Combine

protocol RestAPI {
    
    func callService<Response: Decodable>(url urlString: String,
                                          verb: HTTPMethod,
                                          headers: [String: String]?,
                                          body: [String: Any]?) -> AnyPublisher<Response, Error>
}

extension RestAPI {
    
    func callService<Response: Decodable>(url urlString: String,
                                          verb: HTTPMethod,
                                          headers: [String: String]? = nil,
                                          body: [String: Any]? = nil) -> AnyPublisher<Response, Error> {
        var httpHeaders: HTTPHeaders?
        if let headers =  headers {
            httpHeaders = HTTPHeaders(headers)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let request = AF.request(urlString, method: verb, parameters: body, encoding: URLEncoding.default, headers: httpHeaders)
        let publisher =  request
            .validate()
            .publishDecodable(type: Response.self, decoder: decoder)
            .value()
            .mapError { error -> Error in
                return error
            }
            .eraseToAnyPublisher()
        return publisher
    }
    
}


