//
//  TrackCell.swift
//  IMusic
//
//  Created by Andrey Novikov on 8/3/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit
import SDWebImage

protocol TrackCellViewModel {
    var artistName: String { get }
    var trackName: String { get }
    var collectionName: String? { get }
    var iconUrlString: String? { get }
}

class TrackCell: UITableViewCell {
    
    static let reuseId = "TrackCell"
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    
    // MARK: - Live cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView?.image = nil
    }
    
    // MARK: - Public properties
    
    func configure(trackCellViewModel: TrackCellViewModel) {
        trackNameLabel.text = trackCellViewModel.trackName
        artistNameLabel.text = trackCellViewModel.artistName
        collectionNameLabel.text = trackCellViewModel.collectionName
        
        if let urlString = trackCellViewModel.iconUrlString, let url = URL(string: urlString) {
            trackImageView?.sd_setImage(with: url, completed: nil)
        }
    }
}
