//
//  ImageView+downloaded.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import UIKit

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            
            let cache = NSCache<AnyObject, AnyObject>()

            cache.setObject(image, forKey: url as AnyObject)
            
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from url: String, contentMode mode: ContentMode = .scaleAspectFit) {
        let cache = NSCache<AnyObject, AnyObject>()
        
        if let imageFromCache = cache.object(forKey: url as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        guard let url = URL(string: url) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
