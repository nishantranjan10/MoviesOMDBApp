//
//  MovieDetailsViewModel.swift
//  MoviesOMDBApp
//
//  Created by NISHANT RANJAN on 26/3/22.
//

import Foundation

class MovieDetailsViewModel {
    
    var moviesServices:MoviesServices
    
    init(moviesServices: MoviesServices) {
        
        self.moviesServices = moviesServices
    }
    
    func getMovieDetailsData<T: Decodable>(imdbID : String,objectType: T.Type, completion: @escaping (Result<T>) -> Void) {
        
        let urlString = "\(K.baseUrl)?apikey=\(K.apikey)&i=\(imdbID)"
        
        moviesServices.dataRequest(with: urlString, objectType: objectType.self) { (result: Result) in
        switch result {
         case .success(let object):
            completion(Result.success(object))
                                
            case .failure(let error):
             print(error)
           completion(Result.failure(APPError.jsonParsingError(error)))
            }
        }
    }
}
