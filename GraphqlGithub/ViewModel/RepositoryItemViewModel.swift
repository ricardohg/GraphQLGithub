//
//  RepositoryItemViewModel.swift
//  GraphqlGithub
//
//  Created by ricardo hernandez  on 28/01/21.
//

import Foundation

let imageCache = NSCache<NSString, NSData>()

class RepositoryItemViewModel: ObservableObject {
    
 private let baseUrl = URL(string: "https://www.livesurface.com/test/images")!
    
    @Published var imageData: Data?
    
    func loadImage(for imageUrl: URL) {
        
        // retrieves image data if already available in cache

        if let imageFromCache = imageCache.object(forKey: imageUrl.absoluteString as NSString) {
            self.imageData = Data(imageFromCache)
            return
        }
        
        let task = URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            
            if let data = data {
                
                DispatchQueue.main.async {
                    self.imageData = data
                    imageCache.setObject(NSData(data: data), forKey: imageUrl.absoluteString as NSString)
    
                }
            }
            
        }
        
        task.resume()
        
        
    }
}
