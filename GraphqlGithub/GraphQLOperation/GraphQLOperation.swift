//
//  GraphQLOperation.swift
//  GraphqlGithub
//
//  Created by ricardo hernandez  on 27/01/21.
//


///taken from https://swiftstudent.com/2020-10-09-graphql-networking-using-urlsession/

import Foundation


struct GraphQLResult<T: Decodable>: Decodable {
    let object: T?
    let errorMessages: [String]
    
    enum CodingKeys: String, CodingKey {
        case data
        case errors
    }
    
    struct Error: Decodable {
        let message: String
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let dataDict = try container.decodeIfPresent([String: T].self, forKey: .data)
        self.object = dataDict?.values.first
        
        var errorMessages: [String] = []
        
        let errors = try container.decodeIfPresent([Error].self, forKey: .errors)
        if let errors = errors {
            errorMessages.append(contentsOf: errors.map { $0.message })
        }
        
        self.errorMessages = errorMessages
    }
}

struct PaginationInput: Encodable {
    let after: String?
    let first: Int
}

struct GraphQLOperation<Input: Encodable, Output: Decodable>: Encodable {
    var input: Input
    var operationString: String
    
    private let url = URL(string: "https://api.github.com/graphql")!
    
    enum CodingKeys: String, CodingKey {
        case variables
        case query
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(input, forKey: .variables)
        try container.encode(operationString, forKey: .query)
    }
    
    func getURLRequest(with apiKey: String) throws -> URLRequest {
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(self)
    
        return request
    }
}


extension GraphQLOperation where Input == PaginationInput, Output == Search {
    static func fetchGraphQLRepositories(after cursor: String?, numberOfElements: Int) -> Self {
        GraphQLOperation(
            input: PaginationInput(after: cursor, first: numberOfElements),
            operationString: """
                query SearchGraphQLRepositories($first: Int!, $after: String) {
                 
                search(query: "graphql", type: REPOSITORY, first: $first, after: $after) {
                  repositoryCount
                  pageInfo {
                    hasNextPage
                    endCursor
                  }
                  nodes {
                    ... on Repository {
                      name
                        stargazerCount
                        owner {
                          login
                          avatarUrl
                        }
                    }
                  }

                  }
                }
            """
        )
    }
}
