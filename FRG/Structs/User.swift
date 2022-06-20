//
//  User.swift
//  FRG
//
//  Created by Shanezzar Sharon on 19/06/2022.
//

struct User: Codable, Identifiable {
    var id: Int
    var login: String
    var avatarUrl: String?
    
    static var empty = User(id: 0, login: "", avatarUrl: "")
}
