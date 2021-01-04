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

struct Actor: Codable, Hashable {
    let Id: Int
    let name, bio, image: String
}

