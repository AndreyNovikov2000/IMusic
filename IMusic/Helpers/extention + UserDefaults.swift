//
//  extention + UserDefaults.swift
//  IMusic
//
//  Created by Andrey Novikov on 8/8/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import Foundation

extension UserDefaults {
    static let tracksKey = "tracks"
    
    func saveTracks() -> [SearchViewModel.Cell] {
        let defaults = UserDefaults.standard
        let data = defaults.object(forKey: UserDefaults.tracksKey) as? Data ?? Data()
        var tracks = [SearchViewModel.Cell]()
        
        if let savedTracks = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [SearchViewModel.Cell] {
            tracks.append(contentsOf: savedTracks)
        }
    
        return tracks
    }
}
