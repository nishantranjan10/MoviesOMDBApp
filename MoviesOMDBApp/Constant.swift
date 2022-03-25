//
//  Constant.swift
//  MoviesOMDBApp
//
//  Created by NISHANT RANJAN on 25/3/22.
//

import Foundation

struct K {
        
      static let baseUrl = "http://www.omdbapi.com/"
      static let apikey = "b9bd48a6"
      static let movieList = "MovieList"
      static let moveToDetailScreenSegue = "moveToDetailScreen"
      static let movieDetails = "MovieDetails"
      static let  CellErrorMessage =   "Cell cann't be dequeued"
      static let hour = "h"
      static let minut = "min"
}

extension NSObject {
    class var className: String {
        return String(describing: self)
    }
}
