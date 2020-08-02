//
//  MainTabBarController.swift
//  IMusic
//
//  Created by Andrey Novikov on 8/2/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        
        setupTabBarController()
    }
    
    private func setupTabBarController() {
        let searchViewController = SearchViewController()
        let libraryViewController = LibraryViewController()
        
        viewControllers = [
            generateViewController(withRootViewController: searchViewController, navigationTitle: "Search", tabBarImage: UIImage(systemName: "magnifyingglass")),
            generateViewController(withRootViewController: libraryViewController, navigationTitle: "Library", tabBarImage: UIImage(systemName: "square.and.arrow.down"))
        ]
        
        tabBar.isTranslucent = false
        tabBar.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    }
    
    private func generateViewController(withRootViewController viewController: UIViewController, navigationTitle: String, tabBarImage: UIImage?) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: viewController)
        navigationVC.navigationBar.prefersLargeTitles = true
        navigationVC.tabBarItem.title = navigationTitle
        navigationVC.tabBarItem.image = tabBarImage
        viewController.navigationItem.title = navigationTitle
        return navigationVC
    }
}
