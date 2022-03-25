//
//  MovieListViewModel.swift
//  MoviesOMDBApp
//
//  Created by NISHANT RANJAN on 26/3/22.
//

import Foundation

class MovieListViewModel {
    
     var searchArray : [Search]?
    
     var moviesServices:MoviesServices
    
    init(moviesServices: MoviesServices) {
        self.moviesServices = moviesServices
    }
    
    func getMovieSearchListData<T: Decodable>(movieName : String,pageNumber : String,objectType: T.Type, completion: @escaping (Result<T>) -> Void) {
                 
                  //let movieName = "Batman"
                 let urlString = "\(K.baseUrl)?apikey=\(K.apikey)&s=\(movieName)&page=\(pageNumber)"
                 
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
