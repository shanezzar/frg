//
//  Repository.swift
//  FRG
//
//  Created by Shanezzar Sharon on 19/06/2022.
//

struct Repository: Codable, Identifiable {
    var id, stargazersCount: Int
    let fullName, description, language, defaultBranch, createdAt: String?
    let owner: User
    var readme: String? {
        String("https://raw.githubusercontent.com/\(fullName!)/\(defaultBranch!)/README.md")
    }
    
    static var empty = Repository(id: 0, stargazersCount: 0, fullName: "", description: "", language: "", defaultBranch: "", createdAt: "", owner: .empty)
}
