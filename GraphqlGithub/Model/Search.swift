//
//  Search.swift
//  GraphqlGithub
//
//  Created by ricardo hernandez  on 27/01/21.
//

import Foundation

struct Search: Decodable {
    let repositoryCount: Int
    let nodes: [Repository]
    let pageInfo: PageInfo
    
}

struct PageInfo: Decodable {
    let hasNextPage: Bool
    let endCursor: String
    
}

struct Repository: Decodable {
    let name: String
    let stargazerCount: Int
    let owner: Owner
    
    var itemModel: RepositoryItem {
        return RepositoryItem(name: name, login: owner.login, stargazerCount: stargazerCount, avatarURL: owner.avatarUrl)
    }
}


struct Owner: Decodable {
    let login: String
    let avatarUrl: URL
}


/// Model to populate Items in List View
struct RepositoryItem {
    let name: String
    let login: String
    let stargazerCount: Int
    let avatarURL: URL
}


extension Repository: Identifiable {
    var id: String { return name+owner.login }
}
