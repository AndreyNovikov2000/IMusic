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
    
    var trackCellViewModel: TrackCellViewModel? {
        didSet {
            configure()
        }
    }
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    
    // MARK: - Live cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Private properties
    
    private func configure() {
        trackImageView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        trackNameLabel.text = trackCellViewModel?.trackName
        artistNameLabel.text = trackCellViewModel?.artistName
        collectionNameLabel.text = trackCellViewModel?.collectionName
        
        if let urlString = trackCellViewModel?.iconUrlString, let url = URL(string: urlString) {
            imageView?.sd_setImage(with: url, completed: nil)
        }
    }
}
