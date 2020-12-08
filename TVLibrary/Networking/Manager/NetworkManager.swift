//
//  NetworkManager.swift
//  TVLibrary
//
//  Created by Karol Harasim on 08/12/2020.
//  Copyright © 2020 Karol Harasim. All rights reserved.
//

import Foundation

enum NetworkResponse: String, Error {
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

struct NetworkManager {
//    static let environment : NetworkEnvironment = .production
    static let APIKey = "73622f65fd4eb79f37924c199636fe02"
    let router = Router<SearchApi>()
    
    func getSearchTV(page: Int, query: String, completion: @escaping (_ tvShows: SearchTVApiResponse?,_ error: String?)->()){
        router.request(.tv(page: page, query: query)) { data, response, error in

            if error != nil {
                completion(nil, "Please check your network connection.")
            }

            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
//                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
//                        print(jsonData)
                        let apiResponse = try JSONDecoder().decode(SearchTVApiResponse.self, from: responseData)
//                        print(apiResponse.tvShows.count)
                        completion(apiResponse,nil)
                    }catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError.rawValue)
                }
            }
        }
    }
    
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String, NetworkResponse>{
        switch response.statusCode {
        case 200...299: return .success("OK")
        case 401...500: return .failure(NetworkResponse.authenticationError)
        case 501...599: return .failure(NetworkResponse.badRequest)
        case 600: return .failure(NetworkResponse.outdated)
        default: return .failure(NetworkResponse.failed)
        }
    }
}
