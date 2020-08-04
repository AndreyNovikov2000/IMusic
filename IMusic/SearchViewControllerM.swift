//
//  ViewController.swift
//  IMusic
//
//  Created by Andrey Novikov on 8/2/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewControllerM: UITableViewController {
    
    // MARK: - Private properties
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var timer: Timer?
    private var tarcks = [Result]()
    
    // MARK: - Live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
    }
    
    // MARK: - Private methods
    
    private func setupTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "1")
        tableView.tableFooterView = UIView()
    }
    

}


// MARK: - UITableViewDataSource

extension SearchViewControllerM {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tarcks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "1", for: indexPath)
        cell.textLabel?.text = tarcks[indexPath.row].trackName
        return cell
    }
}


// MARK: - UITableViewDelegate

extension SearchViewControllerM {
    
}


// MARK: - UISearchBarDelegate

extension SearchViewControllerM: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
}


