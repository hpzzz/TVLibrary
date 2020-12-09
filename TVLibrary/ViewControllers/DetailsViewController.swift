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
    var TVShowDetails: TVShowDetails!
    var networkManager: NetworkManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        print(tvShowID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkManager = NetworkManager()
        networkManager.getTVShowDetails(id: tvShowID) { details, error in
        }
        
    }

}
