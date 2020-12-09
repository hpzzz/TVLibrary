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
    case trending(page:Int)
    case topRated(page:Int)
    case details(id:Int)
    case images(id:Int)
}

extension TVShowApi: EndPointType {
    var baseURL: URL {
        guard let url = URL(string: "https://api.themoviedb.org/3/tv/") else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .popular:
            return "popular"
        case .trending:
            return "trending"
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
        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    
}
