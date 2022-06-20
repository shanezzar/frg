//
//  NetworkServiceProtocol.swift
//  FRG
//
//  Created by Shanezzar Sharon on 16/06/2022.
//

import Foundation
import Combine

typealias Header = [String: Any]

protocol NetworkServiceProtocol {
    func get<T: Decodable>(type: T.Type, url: URL, header: Header?) -> AnyPublisher<T, Error>
}
