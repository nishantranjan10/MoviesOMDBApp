//
//  MovieDetails.swift
//  MoviesOMDBApp
//
//  Created by NISHANT RANJAN on 26/3/22.
//

import Foundation

struct MovieDetails: Decodable {
    let Title: String?
    let Year: String?
    let Rated: String?
    let Released: String?
    let Runtime: String?
    let Genre: String?
    let Director: String?
    let Writer: String?
    let Actors: String?
    let Plot: String?
    let Language: String?
    let Country: String?
    let Awards: String?
    let Poster: String?
    let Ratings: [Ratings]?
    let Metascore: String?
    let imdbRating: String?
    let imdbVotes: String?
    let imdbID: String?
    let Type1: String?
    let DVD: String?
    let BoxOffice: String?
    let Production: String?
    let Website: String?
    let Response: String?
    
       enum CodingKeys: String, CodingKey {
       case Title = "Title"
       case Year = "Year"
        case Rated = "Rated"
        case Released = "Released"
        case Runtime = "Runtime"
        case Genre = "Genre"
        case Director = "Director"
        case Writer = "Writer"
        case Actors = "Actors"
        case Plot = "Plot"
        case Language = "Language"
        case Country = "Country"
        case Awards = "Awards"
        case Poster = "Poster"
        case Ratings = "Ratings"
        case Metascore = "Metascore"
        case imdbRating = "imdbRating"
        case imdbVotes = "imdbVotes"
        case imdbID = "imdbID"
        case Type1 = "Type"
        case DVD = "DVD"
        case BoxOffice = "BoxOffice"
        case Production = "Production"
        case Website = "Website"
        case Response = "Response"
       }
    }

struct Ratings : Decodable {
    let Source : String?
    let Value : String?
}
