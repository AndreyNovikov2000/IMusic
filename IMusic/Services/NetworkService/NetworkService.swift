//
//  NetworkService.swift
//  IMusic
//
//  Created by Andrey Novikov on 8/2/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit
import Alamofire

class NetworkService {
    
    func fetchTracks(withText text: String, response:@escaping ([Result]?) -> Void) {
        let url = "https://itunes.apple.com/search"
        let params = ["term":text, "limit": "50", "media": "music"]
        
        AF.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (data) in
            if let error = data.error {
                print("Error - \(error.localizedDescription)")
                response(nil)
                return
            }
            
            guard let data = data.data else { return }
            
            let decoder = JSONDecoder()
            
            do {
                let searchResponsee = try decoder.decode(SearchResponse.self, from: data)
                response(searchResponsee.results)
            } catch let error as NSError {
                print("Error - \(error.userInfo)")
                response(nil)
            }
        }
    }
}

