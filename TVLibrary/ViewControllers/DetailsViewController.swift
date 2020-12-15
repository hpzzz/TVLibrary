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
    var scrollView = DetailsScrollView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.view.addSubview(scrollView)
        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkManager = NetworkManager()
        networkManager.getTVShowDetails(id: tvShowID) { details, error in
            guard details != nil else { return }
            self.tvShowDetails = details
            DispatchQueue.main.async {
                self.scrollView.configure(for: self.tvShowDetails)
                self.title = self.tvShowDetails.name
            }
            
        }

    }
    
}
