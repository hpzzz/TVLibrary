//
//  TVShowDetails.swift
//  TVLibrary
//
//  Created by Karol Harasim on 08/12/2020.
//  Copyright © 2020 Karol Harasim. All rights reserved.
//

import Foundation

struct TVShowDetailsApiResponse: Decodable {
    let backdropPath: String?
    var image: String {
        if let backdrop = backdropPath {
            return "https://image.tmdb.org/t/p/w500\(backdrop)"
        } else {
            return ""
        }
    }
        
    let episodeRunTime: [Int]
    let firstAirDate: String
    let genres: [Genre]
    let homepage: String
    let id: Int
    let inProduction: Bool
    let languages: [String]
    let lastAirDate: String
    let lastEpisodeToAir: LastorNextEpisodeToAir
    let name: String
    let nextEpisodeToAir: LastorNextEpisodeToAir?
    let numberOfEpisodes, numberOfSeasons: Int
    let originCountry: [String]
    let originalLanguage, originalName, overview: String
    let popularity: Double
    let posterPath: String?
    
    var poster: String {
        if let posterPath = posterPath {
            return "https://image.tmdb.org/t/p/w154\(posterPath)"
        } else {
            return ""
        }
    }
    let seasons: [Season]
    let status, tagline, type: String
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case episodeRunTime = "episode_run_time"
        case firstAirDate = "first_air_date"
        case genres, homepage, id
        case inProduction = "in_production"
        case languages
        case lastAirDate = "last_air_date"
        case lastEpisodeToAir = "last_episode_to_air"
        case name
        case nextEpisodeToAir = "next_episode_to_air"
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case seasons
        case status, tagline, type
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
struct Genre: Codable {
    let id: Int
    let name: String
}

struct LastorNextEpisodeToAir: Codable {
    let airDate: String
    let episodeNumber, id: Int
    let name, overview, productionCode: String
    let seasonNumber: Int
    let stillPath: String?
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeNumber = "episode_number"
        case id, name, overview
        case productionCode = "production_code"
        case seasonNumber = "season_number"
        case stillPath = "still_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
struct Season: Codable {
    let airDate: String?
    let episodeCount, id: Int?
    let name, overview: String?
    let posterPath: String?
    let seasonNumber: Int?

    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeCount = "episode_count"
        case id, name, overview
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
    }
}

