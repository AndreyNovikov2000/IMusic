//
//  SearchModels.swift
//  IMusic
//
//  Created by Andrey Novikov on 8/3/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import Foundation
import SwiftUI

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

class SearchViewModel: NSObject, NSCoding {
    @objc(_TtCC6IMusic15SearchViewModel4Cell)class Cell: NSObject, NSCoding, TrackCellViewModel, Identifiable {
        
        var trackName: String
        var artistName: String
        var iconUrlString: String?
        var collectionName: String?
        var previewUrl: String?
        
        
        // Init
        
        init(trackName: String, artistName: String, iconUrlString: String?, collectionName: String?, previewUrl: String?) {
            self.trackName = trackName
            self.artistName = artistName
            self.iconUrlString = iconUrlString
            self.collectionName = collectionName
            self.previewUrl = previewUrl
        }
        
        required init?(coder: NSCoder) {
            trackName = coder.decodeObject(forKey: "trackName") as? String ?? ""
            artistName = coder.decodeObject(forKey: "artistName") as? String ?? ""
            iconUrlString = coder.decodeObject(forKey: "iconUrlString") as? String
            collectionName = coder.decodeObject(forKey: "collectionName") as? String
            previewUrl = coder.decodeObject(forKey: "previewUrl") as? String
        }
        
        // Methods
        
        func encode(with coder: NSCoder) {
              coder.encode(trackName, forKey: "trackName")
              coder.encode(artistName, forKey: "artistName")
              coder.encode(iconUrlString, forKey: "iconUrlString")
              coder.encode(collectionName, forKey: "collectionName")
              coder.encode(previewUrl, forKey: "previewUrl")
          }
    }
    
    // Proprties
    
    let cells: [Cell]
    
    // Init
    
    init(cells: [Cell]) {
        self.cells = cells
    }
    
    required init?(coder: NSCoder) {
        cells = coder.decodeObject(forKey: "cells") as? [SearchViewModel.Cell] ?? []
    }
    
    // Methods
    
    func encode(with coder: NSCoder) {
        coder.encode(cells, forKey: "cells")
    }

}


