//
//  TrendingController.swift
//  TVLibrary
//
//  Created by Karol Harasim on 08/04/2020.
//  Copyright © 2020 Karol Harasim. All rights reserved.
//

import Foundation

class TrendingController {
    
    var dataTask: URLSessionDataTask?
    
    var trendingTVShows: [TVShow] = []
    
    enum Period: String {
        case day
        case week
        
    }
    
    func trendingURL(for period: Period) -> URL{
        let kind = period.rawValue
        let urlString = "https://api.themoviedb.org/3/trending/tv/\(kind)?api_key=73622f65fd4eb79f37924c199636fe02"
        let url = URL(string: urlString)!
        return url

    }
    
    func getTrending(for period: Period, completion: @escaping ((Bool) -> Void)) {
        dataTask?.cancel()
        let url = trendingURL(for: period)
        let session = URLSession.shared
        dataTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
            var success = false
            if let error = error as NSError?, error.code == -999 { return }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                let data = data {
                self.trendingTVShows = self.parse(data: data)
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
