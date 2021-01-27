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
}

struct Owner: Decodable {
    let login: String
    let avatarUrl: URL
}
