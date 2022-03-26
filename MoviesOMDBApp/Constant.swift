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

//Result enum to show success or failure
enum Result<T> {
    case success(T)
    case failure(APPError)
}

//APPError enum which shows all possible errors
      enum APPError: Error {
          case networkError(Error)
          case dataNotFound
          case jsonParsingError(Error)
          case invalidStatusCode(Int)
      }

public enum DownloadResult<T> {
    case sucess(T)
    case faliure(Error)
}
