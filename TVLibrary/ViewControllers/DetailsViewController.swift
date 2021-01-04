//
//  TVShowDetailsViewController.swift
//  TVLibrary
//
//  Created by Karol Harasim on 15/10/2020.
//  Copyright © 2020 Karol Harasim. All rights reserved.
//

import UIKit
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

class DetailsViewController: UIViewController {
    var tvShowID = 0
    var tvShowDetails: TVShowDetailsApiResponse!
    var networkManager: NetworkManager!
    var scrollView = DetailsScrollView()
    var tvShowIsAdded = false
    let realm = try! Realm()
    var inLibrary = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.view.addSubview(scrollView)
        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        scrollView.addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    
    @objc func addButtonTapped(_ action: UIAction) {
        switch inLibrary {
        case true:
            let realm = try! Realm()
            if let show = realm.object(ofType: Show.self, forPrimaryKey: tvShowDetails.id) {
                try! realm.write {
                    realm.delete(show)
                }
            }
        case false:
            let myShow = Show(details: tvShowDetails)
//            myShow.showID = tvShowDetails.id
//            myShow.showName = tvShowDetails.name
//            myShow.nextEpisode = NextEpisode()
//            if let episodeAirDate = tvShowDetails.nextEpisodeToAir?.airDate {
//                myShow.nextEpisode?.episodeDate = episodeAirDate
//            }
//            if let episodeNum = tvShowDetails.nextEpisodeToAir?.episodeNumber {
//                myShow.nextEpisode?.episodeNumber = episodeNum
//            }
//            if let episodeName = tvShowDetails.nextEpisodeToAir?.name {
//                myShow.nextEpisode?.episodeName = episodeName
//            }
//            if let seasonNum = tvShowDetails.nextEpisodeToAir?.seasonNumber {
//                myShow.nextEpisode?.seasonNumber = seasonNum
//            }
            try! realm.write {
                realm.add(myShow)
            }
        }
        inLibrary.toggle()
        scrollView.configureAddButton(inLibrary)

    }
    
    func objectExist (id: Int) -> Bool {
        let realm = try! Realm()
            return realm.object(ofType: Show.self, forPrimaryKey: id) != nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkManager = NetworkManager()
        networkManager.getTVShowDetails(id: tvShowID) { details, error in
            guard details != nil else { return }
            self.tvShowDetails = details
            self.inLibrary = self.objectExist(id: (self.tvShowDetails.id))
            
            
            DispatchQueue.main.async {
                self.scrollView.configure(for: self.tvShowDetails)
                self.scrollView.configureAddButton(self.inLibrary)
                self.title = self.tvShowDetails.name
                
            }
            
        }

    }
    
}
