//
//  MainTabBarController.swift
//  IMusic
//
//  Created by Andrey Novikov on 8/2/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

protocol MainTabBarDelegate: class {
    func minimazeTrackDetailView(_ trackDetailView: TrackDetailView)
    func maximazeTrackDetailView(withViewModel viewModel: SearchViewModel.Cell?)
}

class MainTabBarController: UITabBarController {
    
    // MARK: - Private properties
    
    private lazy var trackDetailView: TrackDetailView = UINib.loadfromNib()
    
    private var minimazedTopAnchorConstraints: NSLayoutConstraint!
    private var maximazedTopAnchorConstraints: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!
    
    
    // MARK: - Live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarController()
        setupTackDetailView()
    }
    
    
    // MARK: - Private porperties
    
    private func setupTabBarController() {
        let searchViewController: SearchViewController = .loadFromSrotyboard()
        searchViewController.tabBarDelegate = self
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
    
    private func setupTackDetailView() {
        trackDetailView.tabBarDelegate = self
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        // use auto layout
        
        maximazedTopAnchorConstraints = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimazedTopAnchorConstraints = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        
        maximazedTopAnchorConstraints.isActive = true
        bottomAnchorConstraint.isActive = true
        
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}



// MARK: - MainTabBarDelegate

extension MainTabBarController: MainTabBarDelegate {
    
    
    func minimazeTrackDetailView(_ trackDetailView: TrackDetailView) {
        
        // animation = maximazedTopAnchorConstraints.fasle -> minimazedTopAnchorConstraints.true
        
        maximazedTopAnchorConstraints.isActive = false
        
        bottomAnchorConstraint.constant = view.frame.height
        
        minimazedTopAnchorConstraints.isActive = true
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
                        
                        self.trackDetailView.trackView.alpha = 1
                        self.trackDetailView.maximizeStackView.alpha = 0
                        self.view.layoutIfNeeded()
                        self.tabBar.alpha = 1
                        
        }) { (_) in
            
        }
    }
    
    func maximazeTrackDetailView(withViewModel viewModel: SearchViewModel.Cell?) {
        
        // animation = minimazedTopAnchorConstraints.false -> maximazedTopAnchorConstraints.true
        minimazedTopAnchorConstraints.isActive = false
        maximazedTopAnchorConstraints.isActive = true
       
        
        bottomAnchorConstraint.constant = 0
        maximazedTopAnchorConstraints.constant = 0
        
        if let viewModel = viewModel {
            trackDetailView.set(viewModel: viewModel)
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
                        
                        self.trackDetailView.trackView.alpha = 0
                        self.trackDetailView.maximizeStackView.alpha = 1
                        self.view.layoutIfNeeded()
                        self.tabBar.alpha = 0
                        
        }) { (_) in
            
        }
    }
}
