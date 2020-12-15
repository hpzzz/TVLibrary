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
        print("Selected view controller")
        print(selectedIndex)
        guard let navigationController = viewControllers?[selectedIndex] as? UINavigationController else { print("nope"); return}
        if navigationController.title != "search" {
            guard let navController = viewControllers?[1] as? UINavigationController else { return }
            guard let vc = navController.viewControllers.first as? SearchViewController else { return }
            guard vc.searchController != nil else { return }
            if vc.searchController.isActive {
                vc.searchController.dismiss(animated: true)
            }
        }
        
//        if vc.searchController.isActive {
//            vc.searchController.isActive.toggle()
//            print("HAHA")
//        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
