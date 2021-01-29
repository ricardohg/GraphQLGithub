//
//  RepositoryItem.swift
//  GraphqlGithub
//
//  Created by ricardo hernandez  on 28/01/21.
//

import Foundation

/// Model to populate Items in List View
struct RepositoryItem: Codable {
    let name: String
    let login: String
    let stargazerCount: Int
    let avatarURL: URL
    let url: URL
    
}

extension RepositoryItem {
    
    /// formatted just for K-order Values
    var formatedStargazerCount: String {
        guard stargazerCount >= 1000 else {
            return "\(stargazerCount)"
        }
        let formatter = NumberFormatter()
        formatter.positiveFormat = "0K"
        formatter.multiplier = 0.001
        return formatter.string(from: NSNumber(value: stargazerCount)) ?? "\(stargazerCount)"
    }
}



