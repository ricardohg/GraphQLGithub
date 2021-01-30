//
//  FavoritesRepositoryListViewModel.swift
//  GraphqlGithub
//
//  Created by ricardo hernandez  on 29/01/21.
//

import Foundation

class FavoritesRepositoryListViewModel: ObservableObject {
    
    @Published var favorites: [RepositoryItem] = []

    private let defaults: UserDefaults
    @Localizable var noFavoritesTitle: String
    
    private var currentFavorites: [RepositoryItem] {
        let decoder = JSONDecoder()
        if let object = defaults.object(forKey: "favorites") as? Data {
            if let favorites = try? decoder.decode([RepositoryItem].self, from: object) {
                return favorites
            }
        }
        return []
    }
    
    init(defaults: UserDefaults, noFavoritesTitle: String) {
        self.defaults = defaults
        self.noFavoritesTitle = noFavoritesTitle
    }
    
    func isFavorite(item: RepositoryItem) -> Bool {
        let favorites = currentFavorites
        return favorites.filter { $0.key == item.key }.count > 0
    }
    

    func loadFavorites() {
        
        self.favorites = currentFavorites
   
    }
    
    func addTo(favorites item: RepositoryItem) {
        let encoder = JSONEncoder()
        var favorites = currentFavorites
        favorites.append(item)
        if let encoded = try? encoder.encode(favorites) {
            defaults.setValue(encoded, forKey: "favorites")
        }
    }
    
}
