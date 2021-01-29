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
    
    @State var heartImage = "heart"
    
    var body: some View {
        
        var image: UIImage!
        let imageData = viewModel.imageData
        
        // Load Image from cache if any, if not load Placeholder
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
                HStack {
                    Image(systemName: "star").foregroundColor(.gray)
                    Text("\(repositoryItem.formatedStargazerCount)").foregroundColor(.gray)
                }
                Spacer()
              
                Image(systemName: self.heartImage)
                    .resizable()
                    .frame(width: 35, height: 35, alignment: .center)
                    .onTapGesture {
                        self.heartImage = self.heartImage == "heart" ? "heart.fill" : "heart"
                    }
                
                Divider()
                Image(uiImage: image)
                    .resizable()
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

