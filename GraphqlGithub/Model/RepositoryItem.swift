//
//  RepositoryItem.swift
//  GraphqlGithub
//
//  Created by ricardo hernandez  on 28/01/21.
//

import Foundation

/// Model to populate Items in List View
struct RepositoryItem {
    let name: String
    let login: String
    let stargazerCount: Int
    let avatarURL: URL
    let url: URL
}
