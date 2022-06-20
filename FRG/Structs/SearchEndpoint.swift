//
//  SearchEndpoint.swift
//  FRG
//
//  Created by Shanezzar Sharon on 16/06/2022.
//

import Foundation

struct SearchEndpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
}

extension SearchEndpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/search" + path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        return url
    }
    
}

extension SearchEndpoint {
    static func searchRepository(query: String, page: Int) -> Self {
        return SearchEndpoint(path: "/repositories", queryItems: [
            URLQueryItem(name: "q", value: "\(query)"),
            URLQueryItem(name: "page", value: "\(page)")
        ])
    }
    
}
