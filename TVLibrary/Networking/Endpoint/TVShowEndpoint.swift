//
//  TVShowEndpoint.swift
//  TVLibrary
//
//  Created by Karol Harasim on 08/12/2020.
//  Copyright © 2020 Karol Harasim. All rights reserved.
//

import Foundation

public enum TVShowApi {
    case popular(page:Int)
    case trending(page:Int, period:Period)
    case topRated(page:Int)
    case details(id:Int)
    case images(id:Int)
}

public enum Period: String {
    case day
    case week
}

extension TVShowApi: EndPointType {
    var baseURL: URL {
        switch self {
        case .trending:
            guard let url = URL(string: "https://api.themoviedb.org/3/trending/tv/") else { fatalError("baseURL could not be configured.")}
            return url
        default:
            guard let url = URL(string: "https://api.themoviedb.org/3/tv/") else { fatalError("baseURL could not be configured.")}
            return url
        }

    }
    
    var path: String {
        switch self {
        case .popular:
            return "popular"
        case .trending(_, let period):
            return "\(period.rawValue)"
        case .topRated:
            return "top_rated"
        case .details(let id):
            return "\(id)"
        case .images(let id):
            return "\(id)/images"
            
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .details(let id), .images(let id):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["api_key":NetworkManager.APIKey,
                                                      "id":id])
        case .popular(let page):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: ["api_key":NetworkManager.APIKey, "page":page]
                                      )
        case .trending(let page, let period):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["api_key":NetworkManager.APIKey,
                                                      "page":page,
                                                      ])
        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    
}
