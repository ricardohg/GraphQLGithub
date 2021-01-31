//
//  MockJSON.swift
//  GraphqlGithubTests
//
//  Created by ricardo hernandez  on 31/01/21.
//

import Foundation

private class EmptyJson {}

/* ☢️ WARNING ☢️
    Don't modify existing JSON files since those are already being used in tests,
    please create new ones with the required data
 */
enum MockJson {
    // MARK: - Json files -
    case search

        
    // MARK: - Vars & Constants -
    private var named: String {
        switch self {
        case .search:
            return "search"
        }
    }
    
    // MARK: - Methods -
    
    func load() -> [String: Any] {
        let bundle = Bundle(for: EmptyJson.self)
        guard let path = bundle.path(forResource: named, ofType: "json") else {
            assertionFailure("Path noth found for json: \(named)")
            return [:]
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            guard let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any] else {
                assertionFailure("Json file \(named) can't be serialized")
                return [:]
            }
            return jsonResult
        } catch(let error) {
            assertionFailure("Trying to load json named \(named) error: \(error.localizedDescription)")
            return [:]
        }
    }
    
    func loadData() -> Data {
        let bundle = Bundle(for: EmptyJson.self)
        guard let path = bundle.path(forResource: named, ofType: "json") else {
            assertionFailure("Path noth found for json: \(named)")
            return Data()
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            return data
        } catch(let error) {
            assertionFailure("Trying to load json named \(named) error: \(error.localizedDescription)")
            return Data()
        }
    }
}
