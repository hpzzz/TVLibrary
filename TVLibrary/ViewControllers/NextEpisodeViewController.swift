//
//  NextEpisodeViewController.swift
//  TVLibrary
//
//  Created by Karol Harasim on 03/01/2021.
//  Copyright © 2021 Karol Harasim. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift
import EventKit

class NextEpisodeViewController: UIViewController {
    
    let eventStore : EKEventStore = EKEventStore()
    lazy private var refreshControl = UIRefreshControl()
    private var tvShows = [Show]()
    private var tableView: UITableView!
    var networkManager: NetworkManager!
    var safeArea: UILayoutGuide!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        super.loadView()
        safeArea = view.layoutMarginsGuide
        setupTableView()
    }
    
    func setupTableView() {
        tableView = UITableView()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getShowsWithNextEpisodeAvailable()
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        updateNextEpisodeAirDate()
        refreshControl.endRefreshing()
    }
    
    func updateNextEpisodeAirDate() {
        //1. get all shows from database
        let realm = try! Realm()
        let shows = realm.objects(Show.self)
        
        networkManager = NetworkManager()
        for show in shows {
            let threadSafe = ThreadSafeReference(to: show)
            networkManager.getTVShowDetails(id: show.showID) { [weak self] details, error in
                guard details != nil else { return }
                let realm = try! Realm()
                guard let details = details,
                      let tvShow = realm.resolve(threadSafe) else { return }
                if details.nextEpisodeToAir?.airDate != tvShow.nextEpisode?.episodeDate {
                    try! realm.write {
                        self?.changeNextEpisodeOfShow(show: tvShow, details: details)
                    }
                }
            }
        }
    }
    
    func changeNextEpisodeOfShow(show: Show, details: TVShowDetailsApiResponse) {
        if let episodeAirDate = details.nextEpisodeToAir?.airDate {
            show.nextEpisode?.episodeDate = episodeAirDate
        }
        if let episodeNum = details.nextEpisodeToAir?.episodeNumber {
            show.nextEpisode?.episodeNumber = episodeNum
        }
        if let episodeName = details.nextEpisodeToAir?.name {
            show.nextEpisode?.episodeName = episodeName
        }
        if let seasonNum = details.nextEpisodeToAir?.seasonNumber {
            show.nextEpisode?.seasonNumber = seasonNum
        }
    }
    
    func getShowsWithNextEpisodeAvailable() {
        let realm = try! Realm()
        tvShows = Array(realm.objects(Show.self).filter("nextEpisode.episodeName != ''"))
        tableView.reloadData()
    }
    
    func episodeInfo(show: Show) -> String {
        if let nextEpisode = show.nextEpisode {
            return String(describing: "Season \(nextEpisode.seasonNumber) Episode \(nextEpisode.episodeNumber), \(nextEpisode.episodeName)")
        }
        else {
            return ""
        }
    }
    
}

extension NextEpisodeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let threadSafe = ThreadSafeReference(to: tvShows[indexPath.row])
        
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            if (granted) && (error == nil) {
                print("granted \(granted)")
                print("error \(String(describing: error))")
                let realm = try! Realm()
                let tvShow = realm.resolve(threadSafe)
                let event:EKEvent = EKEvent(eventStore: self.eventStore)
                event.title = tvShow?.showName
                event.startDate = Date()
                event.endDate = Date()
                event.notes = "This is a note"
                event.calendar = self.eventStore.defaultCalendarForNewEvents
                do {
                    try self.eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
                print("Saved Event")
            }
            else{
                
                print("failed to save event with error : \(String(describing: error)) or access not granted")
            }
        }
    }
}

extension NextEpisodeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let tvShow = tvShows[indexPath.row]
        cell.textLabel?.text = tvShow.showName
        if let nextEpisode = tvShow.nextEpisode {
            cell.detailTextLabel?.text = String(describing: "S\(nextEpisode.seasonNumber)E\(nextEpisode.episodeNumber), \(nextEpisode.episodeName),  \(nextEpisode.episodeDate)")
        }
        
        //        cell.detailTextLabel?.text = "Masno"
        //        cell.detailTextLabel?.font = UIFontMetrics(forTextStyle: .caption1)
        return cell
    }
}
