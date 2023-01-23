//
//  HomeViewController.swift
//  TMDBApp
//
//  Created by Artyom Butorin on 20.01.23.
//

import UIKit

class HomeViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.setupTabBar()
    }
    
    private func setupTabBar() {
        
        self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = .systemBackground
        
        let mainVC = createNavController(viewController: MainTabViewController(),
                                         itemName: "Main",
                                         iconName: "film")
        let favoritesVC = createNavController(viewController: FavoritesViewController(),
                                              itemName: "Favorites",
                                              iconName: "heart")
        let settingsVC = createNavController(viewController: SettingsViewController(),
                                             itemName: "Settings",
                                             iconName: "gear")
        self.setViewControllers([mainVC, favoritesVC, settingsVC], animated: true)
    }
    
    private func createNavController(viewController: UIViewController,
                                     itemName: String,
                                     iconName: String) -> UINavigationController {
        let item = UITabBarItem(title: itemName, image: UIImage(systemName: iconName), tag: 0)
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem = item
        return navController
    }
}
