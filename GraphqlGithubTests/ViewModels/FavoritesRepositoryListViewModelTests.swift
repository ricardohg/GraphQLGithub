//
//  FavoritesRepositoryListViewModel.swift
//  GraphqlGithubTests
//
//  Created by ricardo hernandez  on 31/01/21.
//

import XCTest
@testable import GraphqlGithub

class FavoritesRepositoryListViewModelTests: XCTestCase {
    
    private var viewModel: FavoritesRepositoryListViewModel!
    private let localizedKey = "no.favorites"
    
    override func setUpWithError() throws {
        viewModel = FavoritesRepositoryListViewModel(defaults: UserDefaults(suiteName: #file)!, noFavoritesTitle: localizedKey)
        

    }

    override func tearDownWithError() throws {
        viewModel = nil
    }


    func testAddToFavoritesSuccess() {
        
        guard let testUrl = URL(string: "http://www.test.com") else {
            XCTAssert(false)
            return
        }
        
        let item = RepositoryItem(name: "test", login: "test", stargazerCount: 0, avatarURL: testUrl, url: testUrl)
        // add item to repository
        viewModel.addTo(favorites: item)
        
        // it must be favorite now
        XCTAssert(viewModel.isFavorite(item: item))
        
    }
    
    func testRemoveFromFavoritesSuccess() {
        
        guard let testUrl = URL(string: "http://www.test.com") else {
            XCTAssert(false)
            return
        }
        
        //first add Item to favorites
        
        let item = RepositoryItem(name: "test2", login: "test2", stargazerCount: 0, avatarURL: testUrl, url: testUrl)
        viewModel.addTo(favorites: item)
        XCTAssert(viewModel.isFavorite(item: item))
        
        // remove item
        viewModel.removeFrom(favorites: item)
        // must not be favorite
        XCTAssertFalse(viewModel.isFavorite(item: item))
        
        
    }
    
    func testLocalizedTitleLoadSuccess() {
        
        XCTAssertNotEqual(localizedKey, viewModel.noFavoritesTitle)
    }

}
