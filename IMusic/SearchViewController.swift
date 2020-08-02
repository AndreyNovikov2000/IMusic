//
//  ViewController.swift
//  IMusic
//
//  Created by Andrey Novikov on 8/2/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

struct TrackModel {
    let trackName: String
    let artistName: String
}

class SearchViewController: UITableViewController {

    // MARK: - Private properties
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        setupSearchBar()
    }
    
    // MARK: - Private methods
    
    private func setupTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "1")
        tableView.tableFooterView = UIView()
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.automaticallyShowsCancelButton = false
        searchController.searchBar.delegate = self
    }
}


// MARK: - UITableViewDataSource

extension SearchViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "1", for: indexPath)
        cell.textLabel?.text = "index"
        return cell
    }
}


// MARK: - UITableViewDelegate

extension SearchViewController {
    
}

// MARK: -

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}
