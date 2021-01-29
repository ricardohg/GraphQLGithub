//
//  RepositoryListViewModel.swift
//  GraphqlGithub
//
//  Created by ricardo hernandez  on 27/01/21.
//

import Foundation
import Combine

class RepositoryListViewModel: ObservableObject {
    
    private let apiToken = "bearer a59e5b694b294326443d05e6fb803850034af003"
    private let graphQLURL = URL(string: "https://api.github.com/graphql")!
    
    @Published var repositories: [Repository] = []
    @Published var networkError: NetworkError?
    
    var hasNextPage = true
    var endCursor: String?
    
    private var tempRepositories = [Repository]()
    
    private var cancellable: AnyCancellable?
    
    func searchForGraphQLRepositories(with pageSize: Int, endCursor: String?) {
        
        let operationQuery = GraphQLOperation.fetchGraphQLRepositories(after: endCursor, numberOfElements: pageSize)
        
        let decoder = JSONDecoder()
        
        let request: URLRequest
        
        do {
            request = try operationQuery.getURLRequest(with: apiToken)
        } catch {
            assertionFailure(error.localizedDescription)
            return
        }
        
       cancellable = URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: GraphQLResult<Search>.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
        .catch({ (error) -> AnyPublisher<GraphQLResult<Search>, Never> in
            self.networkError = .underlyingError(error)
            return Empty(completeImmediately: true).eraseToAnyPublisher()
        })
        .sink(receiveValue: { search in
    
            guard let repositories = search.object?.nodes else {
                self.repositories = []
                return
            }
            self.networkError = nil
            self.endCursor = search.object?.pageInfo.endCursor
            self.hasNextPage = search.object?.pageInfo.hasNextPage ?? false
            
            self.tempRepositories.append(contentsOf: repositories)
            self.repositories = self.tempRepositories
        })
        
    }
}

enum NetworkError: LocalizedError, Identifiable {
    case notFound
    case serverError(responseCode: Int)
    case underlyingError(Error)
    case unknown

    var id: String { localizedDescription }

    var errorDescription: String? {
        switch self {
        case .notFound: return "Not found"
        case .serverError(let responseCode): return "Server error \(responseCode)"
        case .underlyingError(let error): return error.localizedDescription
        case .unknown: return "Unknown error"
        }
    }
}
