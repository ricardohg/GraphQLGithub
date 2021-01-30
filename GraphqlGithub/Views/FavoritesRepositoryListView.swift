//
//  FavoritesRepositoryListView.swift
//  GraphqlGithub
//
//  Created by ricardo hernandez  on 29/01/21.
//

import SwiftUI

struct FavoritesRepositoryListView: View {
    
    @StateObject var viewModel = FavoritesRepositoryListViewModel(defaults: .standard, noFavoritesTitle: "no.favorites")
    
    var body: some View {
        
        if viewModel.favorites.count > 0 {
            List {
                ForEach (Array(viewModel.favorites.values)) { favorite in
                    
                    NavigationLink(destination: Webview(url: favorite.url)) {
                        RepositoryItemView(viewModel: RepositoryItemViewModel(with: favorite, favoritesViewModel: viewModel, defaults: .standard))
                    }
                
                }
            }
            .onAppear {
                let _ = self.viewModel.loadFavorites()
            }
        }
        else {
            Text(viewModel.noFavoritesTitle)
                .foregroundColor(.gray)
                .onAppear {
                    let _ = self.viewModel.loadFavorites()
                }
        }
    }
}

