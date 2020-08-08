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
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var addTrackButton: UIButton!
    
    // MARK: - Private properties
    
    var trackCell: SearchViewModel.Cell?
    
    // MARK: - Live cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView?.image = nil
    }
    
    
    // MARK: - IBAction
    
    @IBAction func addTrackAction(_ sender: Any) {
        guard let cell = trackCell else { return }
        addTrackButton.isHidden = true
        let defaults = UserDefaults.standard
        var listOfTracks = defaults.saveTracks()
        listOfTracks.append(cell)
        
        if let savedData =  try? NSKeyedArchiver.archivedData(withRootObject: listOfTracks, requiringSecureCoding: false) {
            defaults.setValue(savedData, forKeyPath: UserDefaults.tracksKey)
        }
    }
    
    
    // MARK: - Public properties
    
    func configure(trackCellViewModel: SearchViewModel.Cell) {
        self.trackCell = trackCellViewModel
        
        trackNameLabel.text = trackCellViewModel.trackName
        artistNameLabel.text = trackCellViewModel.artistName
        collectionNameLabel.text = trackCellViewModel.collectionName
        
        if let urlString = trackCellViewModel.iconUrlString, let url = URL(string: urlString) {
            trackImageView?.sd_setImage(with: url, completed: nil)
        }
        
        checkTrackIsSaved()
    }
    
    // MARK: - Private methods
    
    private func checkTrackIsSaved() {
        let tracks = UserDefaults.standard.saveTracks()
        
        if (tracks.first(where: { $0.trackName == trackCell?.trackName && $0.artistName == trackCell?.artistName }) != nil) {
            addTrackButton.isHidden = true
        } else {
            addTrackButton.isHidden = false
        }
    }
}
