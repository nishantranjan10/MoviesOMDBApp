//
//  UIImageView+Extension.swift
//  MoviesOMDBApp
//
//  Created by NISHANT RANJAN on 26/3/22.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadThumbnail(urlString: String) {
        guard !urlString.isEmpty, let url = URL(string: urlString) else {
            return
        }
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) {
            image = imageFromCache as? UIImage
            return
        }
        
        MoviesServices.downloadImage(url: url) { [weak self]result in
            guard let self = self else {
                return
            }
            
            switch result {
            
            case .sucess(let data):
                guard let imageToCache = UIImage(data: data) else {
                    return
                }
                imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                self.image = UIImage(data: data)
            case .faliure(_):
                DispatchQueue.main.async {
                    self.image = UIImage(named: "default_image")
                }
            }
        }
        
    }
}
