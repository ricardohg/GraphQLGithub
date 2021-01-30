//
//  ContentView.swift
//  GraphqlGithub
//
//  Created by ricardo hernandez  on 27/01/21.
//

import SwiftUI

struct ContentView: View {
    
    let viewModel = ContentViewModel(repositoryTitle: "repository.graphql", favoriteTitle: "favorites")
    
    var body: some View {
        TabView {
            NavigationView {
                RepositoryListView()
                    .navigationTitle(viewModel.repositoryTitle)
            }.tabItem {
                Image(systemName: "externaldrive.badge.icloud")
                Text(viewModel.repositoryTitle)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            
            NavigationView {
                FavoritesRepositoryListView()
                    .navigationTitle(viewModel.favoriteTitle)
                   
            }.tabItem {
                Image(systemName: "heart")
                Text(viewModel.favoriteTitle)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            
            
        }
        
    
         
    }
}

