//
//  RepositoryItemView.swift
//  GraphqlGithub
//
//  Created by ricardo hernandez  on 28/01/21.
//

import SwiftUI

struct RepositoryItemView: View {
    
    var repositoryItem: RepositoryItem
    @ObservedObject var viewModel = RepositoryItemViewModel()
    
    var body: some View {
        
        var image: UIImage!
        let imageData = viewModel.imageData
        
        if let data = viewModel.loadImageFromCache(for: repositoryItem.avatarURL) {
            image = UIImage(data: data)
        }
        else {
            image = UIImage(systemName: "photo")
        }
        
        return Group {
            
            HStack {
                VStack {
                    Text(repositoryItem.name)
                    Text(repositoryItem.login).foregroundColor(.gray)
                }
                Divider()
                Image(systemName: "star")
                Text("\(repositoryItem.stargazerCount)")
                Image(uiImage: image)
                    .resizable()
                    .animation(.default)
                    .frame(width: 50, height: 50, alignment: .center)
                    .aspectRatio(contentMode: .fit)
                    .onAppear {
                        if imageData == nil {
                            self.viewModel.loadImage(for: repositoryItem.avatarURL)
                        }
                    }
                
            }
        }
    }
}

