//
//  TrackDetailView.swift
//  IMusic
//
//  Created by Andrey Novikov on 8/4/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation

protocol TrackDetailViewDelegate: class {
    func trackDetailViewGetPreviousTrack(_ trackDetailView: TrackDetailView) -> SearchViewModel.Cell?
    func trackDetailViewGetNextTrack(_ trackDetailView: TrackDetailView) -> SearchViewModel.Cell?
}

class TrackDetailView: UIView {
    
    // MARK: - Extrnal properties
    
    weak var myDelegate: TrackDetailViewDelegate?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    
    // MARK: - Private properties
    
    private let player: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
    
    private var playerIsPlaying: Bool {
        return player.timeControlStatus == .playing
    }
    
    
    // MARK: - Live cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupTrackImageView()
        motionStartTime()
        observeCurrentTimePlayer()
    }
    
    
    // MARK: - IBAction
    
    @IBAction func dragDownButtonTapped(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @IBAction func handleCurrentTimeSlider(_ sender: Any) {
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let persentage = currentTimeSlider.value
        let newCurrentNewCurrentTime = Float64(persentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(newCurrentNewCurrentTime, preferredTimescale: 1)
        player.seek(to: seekTime)
    }
    
    
    @IBAction func handleVolumeSlider(_ sender: Any) {
        player.volume = volumeSlider.value
    }
    
    @IBAction func previousTrack(_ sender: Any) {
        guard let serachViewModel = myDelegate?.trackDetailViewGetPreviousTrack(self) else { return }
        set(viewModel: serachViewModel)
    }
    
    @IBAction func nextTrack(_ sender: Any) {
        guard let serachViewModel = myDelegate?.trackDetailViewGetNextTrack(self) else { return }
        set(viewModel: serachViewModel)
    }
    
    @IBAction func playPuseTapped(_ sender: Any) {
        if playerIsPlaying {
            reduceTrackImageView()
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            player.pause()
        } else {
            enlargeTrackImageView()
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            player.play()
        }
    }
    
    // MARK: - Public methods
    
    func set(viewModel: SearchViewModel.Cell) {
        authorLabel.text = viewModel.artistName
        trackTitleLabel.text = viewModel.trackName
        
        let iconUrlString600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        if let urlString = iconUrlString600, let imageUrl = URL(string: urlString) {
            trackImageView.sd_setImage(with: imageUrl, completed: nil)
        }
        
        playTrack(previewUrl: viewModel.previewUrl)
    }
    
    
    // MARK: - Private methods
    
    private func setupTrackImageView() {
        trackImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        trackImageView.layer.cornerRadius = 7
        trackImageView.backgroundColor = .green
    }
    
    private func playTrack(previewUrl: String?) {
        guard let urlString = previewUrl, let url = URL(string: urlString) else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    
    private func motionStartTime() {
        let time = CMTime(seconds: 1, preferredTimescale: 3)
        let value = NSValue(time: time)
        player.addBoundaryTimeObserver(forTimes: [value], queue: .main) { [weak self] in
            self?.enlargeTrackImageView()
        }
    }
    
    private func observeCurrentTimePlayer() {
        let interval = CMTime(seconds: 1, preferredTimescale: 3)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            let duration = self?.player.currentItem?.duration ?? CMTime(value: 1, timescale: 1)
            let currentDuration = duration - time
            let progress = Float(CMTimeGetSeconds(time)) / Float(CMTimeGetSeconds(duration))
            
            self?.currentTimeLabel.text = time.convertToString()
            self?.durationLabel.text = currentDuration.convertToString()
            
            guard let self = self else { return }
            guard !self.currentTimeSlider.isHighlighted else { return }
            self.currentTimeSlider.value =  progress
        }
    }
    
    private func updateCurrentTimeSlider() {
        
    }
    
    // MARK: - Animations
    
    private func enlargeTrackImageView() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: [.curveEaseInOut, .curveEaseOut],
                       animations: {
                        
                        self.trackImageView.transform = .identity
                        
        }) { (_) in
        }
    }
    
    private func reduceTrackImageView() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: [.curveEaseInOut, .curveEaseOut],
                       animations: {
                        
                        self.trackImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                        
        }) { (_) in
        }
    }
}
