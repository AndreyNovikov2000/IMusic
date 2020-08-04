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
        let searchViewController: SearchViewController = .loadFromSrotyboard()
        let libraryViewController = LibraryViewController()
        
        viewControllers = [
            generateViewController(withRootViewController: searchViewController, navigationTitle: "Search", tabBarImage: UIImage(systemName: "magnifyingglass")),
            generateViewController(withRootViewController: libraryViewController, navigationTitle: "Library", tabBarImage: UIImage(systemName: "square.and.arrow.down"))
        ]
        
        tabBar.isTranslucent = false
        tabBar.tintColor = #colorLiteral(red: 1, green: 0.5620236723, blue: 0, alpha: 1)
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

