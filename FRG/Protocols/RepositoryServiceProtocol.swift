//
//  RepositoryServiceProtocol.swift
//  FRG
//
//  Created by Shanezzar Sharon on 19/06/2022.
//

import Combine

protocol RepositoryServiceProtocol {
    var networkService: NetworkServiceProtocol { get }
    func searchRepository(_ accessToken: String, query: String, page: Int) -> AnyPublisher<Response, Error>
}
