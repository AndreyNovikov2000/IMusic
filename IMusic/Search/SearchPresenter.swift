//
//  SearchPresenter.swift
//  IMusic
//
//  Created by Andrey Novikov on 8/3/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

protocol SearchPresentationLogic {
    func presentData(response: Search.Model.Response.ResponseType)
}

class SearchPresenter: SearchPresentationLogic {
    weak var viewController: SearchDisplayDataLogic?
    
    func presentData(response: Search.Model.Response.ResponseType) {
        switch response {
        case .responseTracks(let results):
            let cells = results?.map { configureCellViewModel(from: $0) } ?? []
            viewController?.displayData(viewModel: .cellsViewModel(cells))
        case .presentFooterView:
            viewController?.displayData(viewModel: .displayFooterView)
        }
    }
    
    // MARK: - Private methods
    
    private func configureCellViewModel(from results: Result) -> SearchViewModel.Cell {
        return SearchViewModel.Cell.init(trackName: results.trackName,
                                         artistName: results.artistName,
                                         iconUrlString: results.artworkUrl100,
                                         collectionName: results.collectionName,
                                         previewUrl: results.previewUrl)
    }
}

