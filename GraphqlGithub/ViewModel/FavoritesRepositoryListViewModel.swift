//
//  FavoritesRepositoryListViewModel.swift
//  GraphqlGithub
//
//  Created by ricardo hernandez  on 29/01/21.
//

import Foundation

class FavoritesRepositoryListViewModel: ObservableObject {
    
    typealias FavoritesDirectory = [String: RepositoryItem]
    
    @Published var favorites = FavoritesDirectory()

    private let defaults: UserDefaults
    @Localizable var noFavoritesTitle: String
    
    private var currentFavorites: FavoritesDirectory {
        let decoder = JSONDecoder()
        if let object = defaults.object(forKey: "favorites") as? Data {
            if let favorites = try? decoder.decode(FavoritesDirectory.self, from: object) {
                return favorites
            }
        }
        return FavoritesDirectory()
    }
    
    init(defaults: UserDefaults, noFavoritesTitle: String) {
        self.defaults = defaults
        self.noFavoritesTitle = noFavoritesTitle
    }
    
    func isFavorite(item: RepositoryItem) -> Bool {
        let favorites = currentFavorites
        if let _ = favorites[item.key] {
            return true
        }
        return false
    }
    

    func loadFavorites() {
        
        self.favorites = currentFavorites
   
    }
    
    func addTo(favorites item: RepositoryItem) {
        let encoder = JSONEncoder()
        var favorites = currentFavorites
        favorites[item.key] = item
        if let encoded = try? encoder.encode(favorites) {
            defaults.setValue(encoded, forKey: "favorites")
        }
    }
    
    func removeFrom(favorites item: RepositoryItem) {
        
        let encoder = JSONEncoder()
        var favorites = currentFavorites
        favorites.removeValue(forKey: item.key)
        
        if let encoded = try? encoder.encode(favorites) {
            defaults.setValue(encoded, forKey: "favorites")
        }
        
        self.favorites = currentFavorites
    }
    
}
