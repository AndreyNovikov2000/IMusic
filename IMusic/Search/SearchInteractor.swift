//
//  SearchInteractor.swift
//  IMusic
//
//  Created by Andrey Novikov on 8/3/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import Foundation


protocol SearchBusinessLogic {
    func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchBusinessLogic {
    private let networkService = NetworkService()
    
    var presenter: SearchPresentationLogic?
    
    func makeRequest(request: Search.Model.Request.RequestType) {
        
        
        switch request {
        case .requestTrack(let trackName):
            presenter?.presentData(response: .presentFooterView)
            networkService.fetchTracks(withText: trackName) { [weak self] (results) in
                self?.presenter?.presentData(response: .responseTracks(results))
            }
        }
    }
}
