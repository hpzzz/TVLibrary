//
//  SearchViewController.swift
//  TVLibrary
//
//  Created by Karol Harasim on 18/05/2020.
//  Copyright © 2020 Karol Harasim. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var networkManager: NetworkManager!
    var tableView = UITableView()
    lazy var searchBar: UISearchBar = UISearchBar()
    var searchResult: SearchTVApiResponse?
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager = NetworkManager()
    }
    
    override func loadView() {
        super.loadView()
        
        self.searchController = searchControllerWith(searchResultsController: nil)
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.titleView = self.searchController.searchBar
        setupTableView()
    }
    
    struct TableViewCellIdentifiers {
        static let searchResultCell = "SearchResultCell"
        static let nothingFoundCell = "NothingFoundCell"
        static let loadingCell = "LoadingCell"
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.keyboardDismissMode = .onDrag
        tableView.dataSource = self
        tableView.rowHeight = 110
        tableView.delegate = self
        var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
        cellNib = UINib(nibName: TableViewCellIdentifiers.loadingCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell)
        cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tvShows = searchResult?.tvShows else { return 0 }
        guard tvShows.count > 0 else { return 1 }
        return tvShows.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsViewController = DetailsViewController()
        guard let show = searchResult?.tvShows else { return }
        detailsViewController.tvShowID = show[indexPath.row].id
        self.navigationController?.pushViewController(detailsViewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let shows = searchResult?.tvShows else { fatalError("Your shouldnt be there")}
        if shows.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.nothingFoundCell, for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
            let show = shows[indexPath.row]
            cell.configure(for: show)
            return cell
        }
        
    }
}



extension SearchViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.isEmpty {
            return
        }
        networkManager.getSearchTV(page: 1, query: text){  [weak self] shows, error in
                DispatchQueue.main.async {
                    self?.searchResult = shows
                    self?.tableView.reloadData()
                }
        }
        
    }
    
    func searchControllerWith(searchResultsController: UIViewController?) -> UISearchController {
        
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.delegate = self
        searchController.isActive = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController
    }
}
