//
//  SearchViewController.swift
//  TVLibrary
//
//  Created by Karol Harasim on 18/05/2020.
//  Copyright © 2020 Karol Harasim. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    private let search = Search()
    var tableView = UITableView()
    lazy var searchBar: UISearchBar = UISearchBar()
    
    var searchController: UISearchController!
    
    override func loadView() {
        super.loadView()
        
        self.searchController = searchControllerWith(searchResultsController: nil)
        self.navigationItem.titleView = self.searchController.searchBar
        self.searchController.obscuresBackgroundDuringPresentation = false
        setupTableView()

        
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
    
    struct TableViewCellIdentifiers {
        static let searchResultCell = "SearchResultCell"
        static let nothingFoundCell = "NothingFoundCell"
        static let loadingCell = "LoadingCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}


extension SearchViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        search.performSearch(for: text) { (success) in
            if !success {
                print("Oh nonono")
            }
            self.tableView.reloadData()
            print(self.searchController.isActive)
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

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch search.state {
        case .notSearchedYet:
            return 0
        case .loading, .noResults:
            return 1
        case .results(let list):
            return list.count

    }

    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch search.state {
        case .loading, .noResults, .notSearchedYet:
            return nil
        case .results:
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsViewController = TVShowDetailsViewController()
        self.navigationController?.pushViewController(detailsViewController, animated: true)

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch search.state {
        case .notSearchedYet:
            fatalError("You shouldn't het there")
        case .loading:
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.loadingCell, for: indexPath)
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
            
        case .noResults:
            return tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.nothingFoundCell, for: indexPath)
            
        case .results(let list):
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
            let searchResult = list[indexPath.row]
            cell.configure(for: searchResult)
            return cell
        }

    }
}

