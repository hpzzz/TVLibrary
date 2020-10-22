//
//  TVShowBundle.swift
//  TVLibrary
//
//  Created by Karol Harasim on 06/04/2020.
//  Copyright © 2020 Karol Harasim. All rights reserved.
//

import Foundation

struct TrendingResult: Hashable, Codable {
    var results: [TVShow]
}

struct PopularResult: Hashable, Codable {
    var results: [TVShow]
}

struct TVShow: Hashable, Codable {
    var name: String
    var id: Int
    var posterPath: String
    var backdropPath : String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

struct TVShowDetails: Hashable, Codable {
    
}

//struct Trending: TVShow{
//    let originalName: String
//    let id: Int
//    let name: String
//    let voteCount: Int
//    let voteAverage: Double
//    let firstAirDate, posterPath: String
//    let backdropPath, overview: String
//    let popularity: Double
//
//    enum CodingKeys: String, CodingKey {
//        case originalName = "original_name"
//        case id, name
//        case voteCount = "vote_count"
//        case voteAverage = "vote_average"
//        case firstAirDate = "first_air_date"
//        case posterPath = "poster_path"
//        case backdropPath = "backdrop_path"
//        case overview
//        case popularity
//    }
//}

//struct Popular: TVShow{
//    let originalName: String
//    let id: Int
//    let name: String
//    let voteCount: Int
//    let voteAverage: Double
//    let firstAirDate, posterPath: String
//    let backdropPath, overview: String
//    let popularity: Double
//
//    enum CodingKeys: String, CodingKey {
//        case originalName = "original_name"
//        case id, name
//        case voteCount = "vote_count"
//        case voteAverage = "vote_average"
//        case firstAirDate = "first_air_date"
//        case posterPath = "poster_path"
//        case backdropPath = "backdrop_path"
//        case overview
//        case popularity
//    }
//
//}

struct Actor: Codable, Hashable {
    let Id: Int
    let name, bio, image: String
    
    
}

