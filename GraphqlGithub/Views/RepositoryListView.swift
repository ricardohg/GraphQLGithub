//
//  RepositoryListView.swift
//  GraphqlGithub
//
//  Created by ricardo hernandez  on 27/01/21.
//

import SwiftUI

struct RepositoryListView: View {
    
    @StateObject private var viewModel = RepositoryListViewModel()
    
    private let pageSize = 25
    
    var body: some View {
        
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
                
                ForEach(viewModel.repositories) { repository in
                    
                    NavigationLink(destination: Webview(url: repository.itemModel.url)) {
                        RepositoryItemView(repositoryItem: repository.itemModel)
                    }
                }
                
            }
        }.alert(item: self.$viewModel.networkError) { error in
            Alert(title: Text(NSLocalizedString("error", comment: "")), message: Text(error.localizedDescription), dismissButton: .default(Text("Retry")) {
                self.viewModel.searchForGraphQLRepositories(with: self.pageSize, endCursor: viewModel.endCursor)
            })
        }
    }
}

