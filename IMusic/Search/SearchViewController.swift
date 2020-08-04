//
//  SearchViewController.swift
//  IMusic
//
//  Created by Andrey Novikov on 8/3/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

protocol SearchDisplayDataLogic: class {
    func displayData(viewModel: Search.Model.ViewModel.ViewModelType)
}

class SearchViewController: UIViewController, SearchDisplayDataLogic {
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private properties
    private let searchController = UISearchController(searchResultsController: nil)
    private var timer: Timer?
    private var searchViewModel = [SearchViewModel.Cell]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var interactor: SearchBusinessLogic?
    var routing: (NSObjectProtocol & SearchRoutingLogic)?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        setupTableView()
        setupSearchBar()
    }
    
    // MARK: - Setup
    
    func setup() {
        let viewController = self
        let interactor = SearchInteractor()
        let presenter = SearchPresenter()
        let router = SearcRouter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
    
    // MARK: - Routing
    
    func displayData(viewModel: Search.Model.ViewModel.ViewModelType) {
        switch viewModel {
        case .cellsViewModel(let tracks):
            searchViewModel = tracks
        }
    }
    
    // MARK: - Private methods
    
    private func setupTableView() {
        let nib = UINib(nibName: K.NibName.trackCellNibName, bundle: nil)
        tableView.tableFooterView = UIView()
        tableView.register(nib, forCellReuseIdentifier: TrackCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.automaticallyShowsCancelButton = false
        searchController.searchBar.delegate = self
    }
}


// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.reuseId, for: indexPath) as? TrackCell else { fatalError() }
        let trackCellViewModel = searchViewModel[indexPath.row]
        cell.trackCellViewModel = trackCellViewModel
        return cell
    }
}


// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
}


// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false, block: { _ in
            self.interactor?.makeRequest(request: .requestTrack(searchText))
        })
    }
}
