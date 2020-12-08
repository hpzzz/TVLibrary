//
//  SearchEndpoint.swift
//  TVLibrary
//
//  Created by Karol Harasim on 08/12/2020.
//  Copyright © 2020 Karol Harasim. All rights reserved.
//

import Foundation

public enum SearchApi {
    case tv(page:Int, query:String)
    case movie(page:Int, query:String)
    case people(page:Int, query:String)
}

extension SearchApi: EndPointType {
    var baseURL: URL {
        guard let url = URL(string: "https://api.themoviedb.org/3/search/") else { fatalError("baseURL could not be configured")}
        return url
    }
    
    var path: String {
        switch self {
        case .tv:
            return "tv"
        case .movie:
            return "movie"
        case .people:
            return "person"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .tv(let page, let query), .movie(let page, let query), .people(let page, let query):
            print(query)
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["api_key":NetworkManager.APIKey,
                                                      "page":page,
                                                      "query":query])
//        default:
//            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    
}
