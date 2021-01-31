//
//  RepositoryListViewModelTests.swift
//  GraphqlGithubTests
//
//  Created by ricardo hernandez  on 31/01/21.
//

import XCTest
import Combine
@testable import GraphqlGithub

class RepositoryListViewModelTests: XCTestCase {
    
    private var viewModel: RepositoryListViewModel!
    private let localizedKey = "error"

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        viewModel = RepositoryListViewModel(with: localizedKey, defaults: UserDefaults(suiteName: #file)!, provider: SearchMockGraqhQLProvider())
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }

    func testLoadRepositoriesSuccess() {
        
        viewModel.searchForGraphQLRepositories(with: 0, endCursor: nil)
    
        // Wait 
        RunLoop.main.run(mode: .default, before: .distantPast)
        
        XCTAssert(viewModel.repositories.count > 1)
        
    }
    
    func testLocalizedTitleLoadSuccess() {
        
        XCTAssertNotEqual(localizedKey, viewModel.errorString)
    }
    
    struct SearchMockGraqhQLProvider: GraphQLProvider {
        
        func apiResponse(for request: URLRequest) -> AnyPublisher<APIResponse, URLError> {
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
            let data = MockJson.search.loadData()
            return Just((data: data, response: response))
                .setFailureType(to: URLError.self)
                .eraseToAnyPublisher()
        }
        
    }
    
    
}
