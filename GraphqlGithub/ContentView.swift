//
//  ContentView.swift
//  GraphqlGithub
//
//  Created by ricardo hernandez  on 27/01/21.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {
            NavigationView {
                RepositoryListView()
                    .navigationTitle(NSLocalizedString("repository.graphql", comment: ""))
            }.tabItem {
                Image(systemName: "externaldrive.badge.icloud")
                Text(NSLocalizedString("repository.graphql", comment: ""))
            }
            .navigationViewStyle(StackNavigationViewStyle())
            
            NavigationView {
                RepositoryListView()
                    .navigationTitle(NSLocalizedString("favorites", comment: ""))
                   
            }.tabItem {
                Image(systemName: "heart")
                Text(NSLocalizedString("favorites", comment: ""))
            }
            .navigationViewStyle(StackNavigationViewStyle())
            
            
        }
        
    
         
    }
}

