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
    
    // MARK: - Exteranl properties
    
    weak var tabBarDelegate: MainTabBarDelegate?
    
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
    
    private lazy var footerView = FooterView()
    private var curretnIndexPath: IndexPath?
    
    var interactor: SearchBusinessLogic?
    var routing: (NSObjectProtocol & SearchRoutingLogic)?

    // MARK: - Live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        setupTableView()
        setupSearchBar()
        
        searchBar(searchController.searchBar, textDidChange: "Billie eilish")
    }
    
    // MARK: - Selector methods
    

    
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
            footerView.hideLoader()
        case .displayFooterView:
            footerView.showLoader()
        }
    }
    
    // MARK: - Private methods
    
    private func setupTableView() {
        let nib = UINib(nibName: K.NibName.trackCellNibName, bundle: nil)
        tableView.tableFooterView = footerView
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
        cell.configure(trackCellViewModel: trackCellViewModel)
        return cell
    }
}


// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel()
        headerLabel.text = "Please enter search text term..."
        headerLabel.textAlignment = .center
        headerLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        return headerLabel
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return searchViewModel.isEmpty ? 250 : 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = searchViewModel[indexPath.row]
        tabBarDelegate?.maximazeTrackDetailView(withViewModel: viewModel)
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

extension SearchViewController: TrackDetailViewDelegate {
    private func getTrack(isNext: Bool) -> SearchViewModel.Cell? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        tableView.deselectRow(at: indexPath, animated: false)
        var nexIndexPath: IndexPath!
        
        if isNext {
            nexIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            
            if indexPath.row == searchViewModel.count - 1 {
                nexIndexPath = IndexPath(row: 0, section: 0)
            }
            
        } else {
            nexIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            
            if indexPath.row == 0 {
                nexIndexPath = IndexPath(row: searchViewModel.count - 1, section: indexPath.section)
            }
        }
        
        tableView.selectRow(at: nexIndexPath, animated: false, scrollPosition: .none)
    
        return searchViewModel[nexIndexPath.row]
    }
    
    func trackDetailViewGetPreviousTrack(_ trackDetailView: TrackDetailView) -> SearchViewModel.Cell? {
        return getTrack(isNext: false)
    }
    
    func trackDetailViewGetNextTrack(_ trackDetailView: TrackDetailView) -> SearchViewModel.Cell? {
        return getTrack(isNext: true)
    }
}
