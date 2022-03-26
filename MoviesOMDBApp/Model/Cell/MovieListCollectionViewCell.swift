//
//  MovieListCollectionViewCell.swift
//  MoviesOMDBApp
//
//  Created by NISHANT RANJAN on 25/3/22.
//

import Foundation
import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var searchList: Search? {
        
        didSet {
           
            if let title = searchList?.Title {
                self.titleLabel.text = "Title : \(title)"
            }
            
            self.imageView.loadThumbnail(urlString: searchList?.Poster ?? "")
        }
    }
}
