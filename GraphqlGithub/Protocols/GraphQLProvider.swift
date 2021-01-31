//
//  GraphQLProvider.swift
//  GraphqlGithub
//
//  Created by ricardo hernandez  on 31/01/21.
//

import Foundation
import Combine


///https://stackoverflow.com/questions/60089803/how-to-mock-datataskpublisher

protocol GraphQLProvider {
    typealias APIResponse = URLSession.DataTaskPublisher.Output
    func apiResponse(for request: URLRequest) -> AnyPublisher<APIResponse, URLError>
}

extension URLSession: GraphQLProvider {
    func apiResponse(for request: URLRequest) -> AnyPublisher<APIResponse, URLError> {
        return dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
}
