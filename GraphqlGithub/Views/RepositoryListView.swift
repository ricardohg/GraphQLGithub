//
//  RepositoryListView.swift
//  GraphqlGithub
//
//  Created by ricardo hernandez  on 27/01/21.
//

import SwiftUI

struct RepositoryListView: View {
    
    @StateObject var remote = RepositoryListViewModel()
    
    private let pageSize = 25
    
    var body: some View {
        if let repositories = remote.repositories {
            
            switch repositories {
            case .success(let repositories):
                
                List {
                    Section(footer:
                                Group {
                                    if remote.hasNextPage {
                                        ProgressView()
                                            .onAppear {
                                                self.remote.searchForGraphQLRepositories(with: self.pageSize, endCursor: remote.endCursor)
                                            }
                                    }
                                }
                    ) {
                        
                        ForEach(repositories) { repository in
                            
                            HStack {
                                VStack {
                                    Text(repository.name)
                                    Text(repository.owner.login).foregroundColor(.gray)
                                }
                                Divider()
                                Image(systemName: "star")
                                Text("\(repository.stargazerCount)")
                            }
                            
                            
                            
                        }
                        
                    }
                }
                
            case .failure(let error):
                Text(error.localizedDescription)
            }
            
            
        }
        else {
            ProgressView()
                .onAppear {
                    self.remote.searchForGraphQLRepositories(with: self.pageSize, endCursor: nil)
                }
        }
    }
}
