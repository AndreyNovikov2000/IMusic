//
//  TrackDetailView.swift
//  IMusic
//
//  Created by Andrey Novikov on 8/4/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit
import SDWebImage

class TrackDetailView: UIView {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UIStackView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var tracktitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    
    // MARK: - Live cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        trackImageView.backgroundColor = .green
    }

    
    // MARK: - IBAction
    
    @IBAction func dragDownButtonTapped(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @IBAction func handleCurrentTimeSlider(_ sender: Any) {
    }
    
    @IBAction func handleVolumeSlider(_ sender: Any) {
    }
    
    @IBAction func previousTrack(_ sender: Any) {
    }
    
    @IBAction func nextTrack(_ sender: Any) {
    }
    
    @IBAction func playPuseTapped(_ sender: Any) {
        
    }
    
    // MARK: - Public methods
    
    func set(viewModel: SearchViewModel.Cell) {
        authorLabel.text = viewModel.artistName
        tracktitleLabel.text = viewModel.trackName
        
        let iconUrlString600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        if let urlString = iconUrlString600, let imageUrl = URL(string: urlString) {
            trackImageView.sd_setImage(with: imageUrl, completed: nil)
        }
    }
}
