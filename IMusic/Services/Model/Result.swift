//
//  Result.swift
//  IMusic
//
//  Created by Andrey Novikov on 8/2/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import Foundation


struct SearchResponse: Decodable {
    let resultCount: Int
    let results: [Result]
}

struct Result: Decodable {
    let artistName: String
    let trackName: String
    let artworkUrl100: String?
    let previewUrl: String?
    var collectionName: String?
}
