//
//  SearchModels.swift
//  IMusic
//
//  Created by Andrey Novikov on 8/3/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import Foundation

struct Search {
    enum Model {
        struct Request {
            enum RequestType {
                case requestTrack(String)
            }
        }
        
        struct Response {
            enum ResponseType {
                case responseTracks([Result]?)
                case presentFooterView
            }
        }
        
        struct ViewModel {
            enum ViewModelType {
                case cellsViewModel([SearchViewModel.Cell])
                case displayFooterView
            }
        }
    }
}

struct SearchViewModel {
    struct Cell: TrackCellViewModel {
        var trackName: String
        var artistName: String
        var iconUrlString: String?
        var collectionName: String?
        var previewUrl: String?
    }
    
    let cells: [Cell]
}


