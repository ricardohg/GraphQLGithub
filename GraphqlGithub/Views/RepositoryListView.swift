//
//  RepositoryListView.swift
//  GraphqlGithub
//
//  Created by ricardo hernandez  on 27/01/21.
//

import SwiftUI

struct RepositoryListView: View {
    
    @StateObject var viewModel = RepositoryListViewModel()
    
    private let pageSize = 25
    
    var body: some View {
        if let repositories = viewModel.repositories {
            
            switch repositories {
            case .success(let repositories):
                
                List {
                    Section(footer:
                                Group {
                                    if viewModel.hasNextPage {
                                        ProgressView()
                                            .onAppear {
                                                self.viewModel.searchForGraphQLRepositories(with: self.pageSize, endCursor: viewModel.endCursor)
                                            }
                                    }
                                }
                    ) {
                        
                        ForEach(repositories) { repository in
                            
                            NavigationLink(destination: Webview(url: repository.itemModel.url)) {
                                RepositoryItemView(repositoryItem: repository.itemModel)
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
                    self.viewModel.searchForGraphQLRepositories(with: self.pageSize, endCursor: nil)
                }
        }
    }
}

