//
//  RepositoryItemViewModel.swift
//  GraphqlGithub
//
//  Created by ricardo hernandez  on 28/01/21.
//

import Foundation
import Combine

let imageCache = NSCache<NSString, NSData>()

class RepositoryItemViewModel: ObservableObject {
    
    @Published var imageData: Data?
    
    private var cancellable: AnyCancellable?
    
    func loadImageFromCache(for imageURL: URL) -> Data? {
        if let imageFromCache = imageCache.object(forKey: imageURL.absoluteString as NSString) {
            return Data(imageFromCache)
        }
        return nil
    }
    
    func loadImage(for imageURL: URL) {
        
       cancellable =  URLSession.shared.dataTaskPublisher(for: imageURL)
            .map { $0.data }
        .receive(on: DispatchQueue.main)
        .catch({ error -> AnyPublisher<Data, Never> in
            self.imageData = nil
            print(error.localizedDescription)
            return Empty(completeImmediately: true).eraseToAnyPublisher()
        })
        .sink(receiveValue: { data in
            imageCache.setObject(NSData(data: data), forKey: imageURL.absoluteString as NSString)
            self.imageData = data
        })
        
        
        
    }
}
