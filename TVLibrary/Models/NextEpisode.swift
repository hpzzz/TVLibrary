//
//  NextEpisode.swift
//  TVLibrary
//
//  Created by Karol Harasim on 04/01/2021.
//  Copyright © 2021 Karol Harasim. All rights reserved.
//

import Foundation
import RealmSwift

class Show: Object {
    
    @objc dynamic var showID: Int = 0
    @objc dynamic var showName: String = ""
    @objc dynamic var nextEpisode: NextEpisode? = nil

    override static func primaryKey() -> String? {
            return "showID"
        }
    
    func nextEpisodeDescription() -> String {
        return String(describing: "")
    }
    
    convenience init(details: TVShowDetailsApiResponse) {
        self.init()
        self.showID = details.id
        self.showName = details.name
        self.nextEpisode = NextEpisode()
        if let episodeAirDate = details.nextEpisodeToAir?.airDate {
            self.nextEpisode?.episodeDate = episodeAirDate
        }
        if let episodeNum = details.nextEpisodeToAir?.episodeNumber {
            self.nextEpisode?.episodeNumber = episodeNum
        }
        if let episodeName = details.nextEpisodeToAir?.name {
            self.nextEpisode?.episodeName = episodeName
        }
        if let seasonNum = details.nextEpisodeToAir?.seasonNumber {
            self.nextEpisode?.seasonNumber = seasonNum
        }
    }
    
    func assignFromDetails(details: TVShowDetailsApiResponse) {
        self.showID = details.id
        self.showName = details.name
        self.nextEpisode = NextEpisode()
        if let episodeAirDate = details.nextEpisodeToAir?.airDate {
            self.nextEpisode?.episodeDate = episodeAirDate
        }
        if let episodeNum = details.nextEpisodeToAir?.episodeNumber {
            self.nextEpisode?.episodeNumber = episodeNum
        }
        if let episodeName = details.nextEpisodeToAir?.name {
            self.nextEpisode?.episodeName = episodeName
        }
        if let seasonNum = details.nextEpisodeToAir?.seasonNumber {
            self.nextEpisode?.seasonNumber = seasonNum
        }
    }
}

class NextEpisode: Object {
    @objc dynamic var episodeDate: String = ""
    @objc dynamic var episodeNumber: Int = 0
    @objc dynamic var episodeName: String = ""
    @objc dynamic var seasonNumber: Int = 0
}
