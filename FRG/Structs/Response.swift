//
//  Response.swift
//  FRG
//
//  Created by Shanezzar Sharon on 19/06/2022.
//

struct Response: Codable {
    let totalCount: Int
    let items: [Repository]
    
    static var empty = Response(totalCount: 0, items: [])
}
