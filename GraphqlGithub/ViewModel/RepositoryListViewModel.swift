//
//  RepositoryListViewModel.swift
//  GraphqlGithub
//
//  Created by ricardo hernandez  on 27/01/21.
//

import Foundation
import Combine

class RepositoryListViewModel: ObservableObject {
    
    private let apiToken = "bearer \(AppConstants.githubToken)"
    private let graphQLURL = URL(string: "https://api.github.com/graphql")!
    
    @Published var repositories: [Repository] = []
    @Published var networkError: NetworkError?
    
    @Localizable var errorString: String
    
    let provider: GraphQLProvider
    
    var hasNextPage = true
    var endCursor: String?
    
    private var tempRepositories = [Repository]()
    
    private var cancellable: AnyCancellable?
    
    init(with errorString: String, defaults: UserDefaults, provider: GraphQLProvider) {
        self.errorString = errorString
        self.provider = provider
    }
    
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
        
        let dataTask = provider.apiResponse(for: request)
        
        cancellable = dataTask
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
