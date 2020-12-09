//
//  TVShowDetailsViewController.swift
//  TVLibrary
//
//  Created by Karol Harasim on 15/10/2020.
//  Copyright © 2020 Karol Harasim. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    var tvShowID = 0
    var tvShowDetails: TVShowDetailsApiResponse!
    var networkManager: NetworkManager!
    lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to library", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.systemBlue, for: .normal)
//        button.addTarget(self, action: #selector(showAllPopular), for: .touchUpInside)
        button.backgroundColor = .clear
        return button
    }()
    //    var scrollView: DetailsScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        //        scrollView = DetailsScrollView()
        //        view.addSubview(scrollView)
        //        NSLayoutConstraint.activate([
        //                                        scrollView.topAnchor.constraint(
        //                                            equalTo: view.safeAreaLayoutGuide.topAnchor),
        //            scrollView.trailingAnchor.constraint(
        //                equalTo: view.trailingAnchor),
        //            scrollView.leadingAnchor.constraint(
        //                equalTo: view.leadingAnchor),
        //            scrollView.bottomAnchor.constraint(
        //                equalTo: view.bottomAnchor),
        //            scrollView.stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        //        ])
        //        print(2)
        //        print(tvShowID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkManager = NetworkManager()
        networkManager.getTVShowDetails(id: tvShowID) { details, error in
            guard details != nil else { return }
            self.tvShowDetails = details
        }

    }
    
}
