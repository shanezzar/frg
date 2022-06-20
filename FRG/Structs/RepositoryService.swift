//
//  RepositoryService.swift
//  FRG
//
//  Created by Shanezzar Sharon on 19/06/2022.
//

import Combine

struct RepositoryService: RepositoryServiceProtocol {
    var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func searchRepository(_ accessToken: String, query: String, page: Int) -> AnyPublisher<Response, Error> {
        let endpoint = SearchEndpoint.searchRepository(query: query, page: page)
        return networkService.get(type: Response.self, url: endpoint.url, header: ["Authorization": "Basic \(accessToken)"])
    }

}
