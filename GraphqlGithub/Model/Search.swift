//
//  Search.swift
//  GraphqlGithub
//
//  Created by ricardo hernandez  on 27/01/21.
//

import Foundation

// Models to represent Search Object returned from Github's GraphQL request

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
    let url: URL
    
    var itemModel: RepositoryItem {
        return RepositoryItem(name: name, login: owner.login, stargazerCount: stargazerCount, avatarURL: owner.avatarUrl, url: url)
    }
}

struct Owner: Decodable {
    let login: String
    let avatarUrl: URL
}

extension Repository: Identifiable {
    var id: String { return name+owner.login }
}
