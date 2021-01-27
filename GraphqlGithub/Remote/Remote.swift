//
//  Remote.swift
//  GraphqlGithub
//
//  Created by ricardo hernandez  on 27/01/21.
//

import Foundation
import Combine

class Remote: ObservableObject {
    
    private let apiToken = "bearer a59e5b694b294326443d05e6fb803850034af003"
    private let graphQLURL = URL(string: "https://api.github.com/graphql")!
    
    @Published var searches: Result<[Repository], Error>? = nil
    private var cancellable: AnyCancellable?
    
    func searchForGraphQLRepositories(with pageSize: Int, endCursor: String?) {
        
        let operationQuery = GraphQLOperation.fetchGraphQLRepositories(after: endCursor, numberOfElements: pageSize)
        
        let decoder = JSONDecoder()
        
        let request: URLRequest
        
        do {
            request = try operationQuery.getURLRequest(with: apiToken)
        } catch {
            searches = .failure(error)
            return
        }
        
       cancellable = URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: GraphQLResult<Search>.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
        .catch({ (error) -> AnyPublisher<GraphQLResult<Search>, Never> in
            self.searches = .failure(error)
            return Empty(completeImmediately: true).eraseToAnyPublisher()
        })
        .sink(receiveValue: { search in
    
            guard let repositories = search.object?.nodes else {
                self.searches = .success([])
                return
            }
            self.searches = .success(repositories)
        })
        
    }
}
