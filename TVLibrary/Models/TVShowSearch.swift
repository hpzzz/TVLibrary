//
//  TVShowSearch.swift
//  TVLibrary
//
//  Created by Karol Harasim on 09/12/2020.
//  Copyright © 2020 Karol Harasim. All rights reserved.
//

import Foundation

struct SearchTVApiResponse {
    let page: Int
    let numberOfResults: Int
    let numberOfPages: Int
    let tvShows: [SearchResult]
}

extension SearchTVApiResponse: Decodable {
    
    private enum MovieApiResponseCodingKeys: String, CodingKey {
        case page
        case numberOfResults = "total_results"
        case numberOfPages = "total_pages"
        case tvShows = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MovieApiResponseCodingKeys.self)
        
        page = try container.decode(Int.self, forKey: .page)
        numberOfResults = try container.decode(Int.self, forKey: .numberOfResults)
        numberOfPages = try container.decode(Int.self, forKey: .numberOfPages)
        tvShows = try container.decode([SearchResult].self, forKey: .tvShows)
    }
}

class SearchResult: Codable {
    let originalName: String
    let genreIDS: [Int]
    let name: String
    let popularity: Double
    let originCountry: [String]
    let voteCount: Int
    let firstAirDate: String?
    let backdropPath: String?
//    let originalLanguage: OriginalLanguage
    let id: Int
    let voteAverage: Double
    let overview: String
    let posterPath: String?
    var image: String {
        if let poster = posterPath {
            return "https://image.tmdb.org/t/p/w92\(poster)"
        } else {
            return ""
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case originalName = "original_name"
        case genreIDS = "genre_ids"
        case name, popularity
        case originCountry = "origin_country"
        case voteCount = "vote_count"
        case firstAirDate = "first_air_date"
        case backdropPath = "backdrop_path"
//        case originalLanguage = "original_language"
        case id
        case voteAverage = "vote_average"
        case overview
        case posterPath = "poster_path"
    }
}
