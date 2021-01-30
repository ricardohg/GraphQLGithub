//
//  RepositoryItemView.swift
//  GraphqlGithub
//
//  Created by ricardo hernandez  on 28/01/21.
//

import SwiftUI

struct RepositoryItemView: View {
    
    @ObservedObject var viewModel: RepositoryItemViewModel 
    
    @State var heartImage = "heart"
    
    var body: some View {
        
        var image: UIImage!
        let imageData = viewModel.imageData
        
        // Load Image from cache if any, if not load Placeholder
        if let data = viewModel.loadImageFromCache() {
            image = UIImage(data: data)
        }
        else {
            image = UIImage(systemName: "photo")
        }
        
        return Group {
            
            HStack {
                VStack {
                    Text(viewModel.item.name)
                    Text(viewModel.item.login).foregroundColor(.gray)
                }
                Divider()
                HStack {
                    Image(systemName: "star").foregroundColor(.gray)
                    Text("\(viewModel.item.formatedStargazerCount)").foregroundColor(.gray)
                }
                Spacer()
              
                Image(systemName: self.viewModel.favoritesViewModel.isFavorite(item: viewModel.item) ? "heart.fill" : "heart")
                    .resizable()
                    .frame(width: 35, height: 35, alignment: .center)
                    .onTapGesture {
                        self.viewModel.favoritesViewModel.addTo(favorites: viewModel.item)
                        self.heartImage = self.viewModel.favoritesViewModel.isFavorite(item: viewModel.item) ? "heart.fill" : "heart"
                    }
                
                Divider()
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                    .aspectRatio(contentMode: .fit)
                    .onAppear {
                        if imageData == nil {
                            self.viewModel.loadImage()
                        }
                    }
                
            }
            
       
        }
    }
}

