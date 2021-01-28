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
    
    @Published var repositories: Result<[Repository], Error>? = nil
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
            repositories = .failure(error)
            return
        }
        
       cancellable = URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: GraphQLResult<Search>.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
        .catch({ (error) -> AnyPublisher<GraphQLResult<Search>, Never> in
            self.repositories = .failure(error)
            return Empty(completeImmediately: true).eraseToAnyPublisher()
        })
        .sink(receiveValue: { search in
    
            guard let repositories = search.object?.nodes else {
                self.repositories = .success([])
                return
            }
            self.endCursor = search.object?.pageInfo.endCursor
            self.hasNextPage = search.object?.pageInfo.hasNextPage ?? false
            
            self.tempRepositories.append(contentsOf: repositories)
            self.repositories = .success(self.tempRepositories)
        })
        
    }
}
