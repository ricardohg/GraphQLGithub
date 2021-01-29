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
            }.tabItem {
                Image(systemName: "externaldrive.badge.icloud")
                Text("GraphQL Repositories")
            }
            
            NavigationView {
                RepositoryListView()
                   
            }.tabItem {
                Image(systemName: "heart")
                Text("Favorites")
            }
            
            
        }
        
    
         
    }
}

