//
//  TabBarController.swift
//  TVLibrary
//
//  Created by Karol Harasim on 15/12/2020.
//  Copyright © 2020 Karol Harasim. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

        // Do any additional setup after loading the view.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let navigationController = viewControllers?[selectedIndex] as? UINavigationController else { print("nope"); return}
        if navigationController.title != "search" {
            guard let navController = viewControllers?[1] as? UINavigationController else { return }
            guard let vc = navController.viewControllers.first as? SearchViewController else { return }
            guard vc.searchController != nil else { return }
            if vc.searchController.isActive {
                vc.searchController.dismiss(animated: true)
            }
        }
    }
}
