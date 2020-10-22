//
//  SearchResult.swift
//  TVLibrary
//
//  Created by Karol Harasim on 22/10/2020.
//  Copyright © 2020 Karol Harasim. All rights reserved.
//

import Foundation

class ResultArray: Codable {
    var resultCount = 0
    var resultArray = [SearchResult]()
}

class SearchResult: Codable {
    let originalName: String
       let genreIDS: [Int]
       let name: String
       let popularity: Double
       let originCountry: [String]
       let voteCount: Int
       let firstAirDate: String
       let backdropPath: String?
       let originalLanguage: OriginalLanguage
       let id: Int
       let voteAverage: Double
       let overview: String
       let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case originalName = "original_name"
        case genreIDS = "genre_ids"
        case name, popularity
        case originCountry = "origin_country"
        case voteCount = "vote_count"
        case firstAirDate = "first_air_date"
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case id
        case voteAverage = "vote_average"
        case overview
        case posterPath = "poster_path"
    }
    
    enum OriginalLanguage: String, Codable {
        case en = "en"
        case ja = "ja"
        case ko = "ko"
    }
}
