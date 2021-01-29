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
    
    let item: RepositoryItem
    
    private var cancellable: AnyCancellable?
    
    init(with item: RepositoryItem) {
        self.item = item
    }
    
    func loadImageFromCache() -> Data? {
        if let imageFromCache = imageCache.object(forKey: item.avatarURL.absoluteString as NSString) {
            return Data(imageFromCache)
        }
        return nil
    }
    
    func loadImage() {
        
        // get 100px image size
        let queryItem = [URLQueryItem(name: "s", value: "100")]
        var urlComponent = URLComponents(string: item.avatarURL.absoluteString)
        urlComponent?.queryItems = queryItem
        
        guard let url = urlComponent?.url else { return }
        
       cancellable =  URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
        .receive(on: DispatchQueue.main)
        .catch({ error -> AnyPublisher<Data, Never> in
            self.imageData = nil
            print(error.localizedDescription)
            return Empty(completeImmediately: true).eraseToAnyPublisher()
        })
        .sink(receiveValue: { data in
            imageCache.setObject(NSData(data: data), forKey: self.item.avatarURL.absoluteString as NSString)
            self.imageData = data
        })
    }
}

