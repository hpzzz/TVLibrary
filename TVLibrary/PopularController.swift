//
//  PopularController.swift
//  TVLibrary
//
//  Created by Karol Harasim on 13/04/2020.
//  Copyright © 2020 Karol Harasim. All rights reserved.
//

import Foundation

class PopularController {
    
    var dataTask: URLSessionDataTask?
    var popularTVShows: [TVShow] = []
    
    
    func popularURL() -> URL {
        let urlString = "https://api.themoviedb.org/3/tv/popular?api_key=73622f65fd4eb79f37924c199636fe02"
        let url = URL(string: urlString)!
        return url
    }
    
    func getPopular(completion: @escaping ((Bool) -> Void)) {
        dataTask?.cancel()
        let url = popularURL()
        let session = URLSession.shared
        dataTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
            var success = false
            if let error = error as NSError?, error.code == -999 { return }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                let data = data {
                self.popularTVShows = self.parse(data: data)
                success = true
            }
            
            DispatchQueue.main.async {
                completion(success)
            }
        })
        dataTask?.resume()
    }
    
    func parse(data: Data) -> [TVShow] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(TrendingResult.self, from: data)
            return result.results
        } catch {
            print("JSONError")
            return []
        }
    }
}
