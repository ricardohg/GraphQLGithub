//
//  GraphQLResultTests.swift
//  GraphqlGithubTests
//
//  Created by ricardo hernandez  on 31/01/21.
//

import XCTest
@testable import GraphqlGithub

class GraphQLResultTests: XCTestCase {

    
    func testParseSearchSuccess() {
        
        let data = MockJson.search.loadData()
        
        let decoder = JSONDecoder()
        
        let graphQLResult = try? decoder.decode(GraphQLResult<Search>.self, from: data)
        
        XCTAssertNotNil(graphQLResult)
    }

}
