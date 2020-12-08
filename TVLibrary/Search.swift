//
//  Search.swift
//  TVLibrary
//
//  Created by Karol Harasim on 22/10/2020.
//  Copyright © 2020 Karol Harasim. All rights reserved.
//

import Foundation

typealias SearchComplete = (Bool) -> Void

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

class Search {
    
    enum State {
        case notSearchedYet
        case loading
        case noResults
        case results([SearchResult])
    }
    
    private(set) var state: State = .notSearchedYet
    private var dataTask: URLSessionDataTask? = nil
    
    func performSearch(for text: String, completion: @escaping SearchComplete) {
        if !text.isEmpty {
            dataTask?.cancel()
            state = .loading
            
            let url = searchURL(searchText: text)
            let session = URLSession.shared
            dataTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
                var newState = State.notSearchedYet
                var success = false
                if let error = error as NSError?, error.code == -999 {
                    newState = .noResults
                    return
                }
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data {
                    let searchResults = self.parse(data: data)
                    if searchResults.isEmpty {
                        newState = .noResults
                    } else {
                        newState = .results(searchResults)
                    }
                    success = true
                }
                DispatchQueue.main.async {
                    self.state = newState
                    completion(success)
                }
            })
            dataTask?.resume()
        }
    }
    
    func searchURL(searchText: String) -> URL {
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlString = "https://api.themoviedb.org/3/search/tv?api_key=73622f65fd4eb79f37924c199636fe02&page=1&query=\(encodedText)"
        let url = URL(string: urlString)
        return url!
    }
    
    private func parse(data: Data) -> [SearchResult] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultArray.self, from: data)
            return result.results
        } catch {
            print("JSON error \(error)")
            return []
        }
    }
    
}
