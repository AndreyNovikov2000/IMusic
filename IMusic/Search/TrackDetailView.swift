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
    weak var tabBarDelegate: MainTabBarDelegate?
    
    // MARK: - IBOutlets
    
    // Minimized player UI
    @IBOutlet weak var trackView: UIView!
    @IBOutlet weak var goNextPlayerButton: UIButton!
    @IBOutlet weak var playerTrackImageView: UIImageView!
    @IBOutlet weak var playerTrackTitleLabel: UILabel!
    @IBOutlet weak var playerTrackPlayPauseButton: UIButton! {
        didSet {
            playerTrackPlayPauseButton.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
        }
    }
    
    // Maximized player UI
    @IBOutlet weak var maximizeStackView: UIStackView!
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
        setupGestues()
        
        motionStartTime()
        observeCurrentTimePlayer()
    }
    
    
    // MARK: - IBAction
    
    @IBAction func dragDownButtonTapped(_ sender: Any) {
        tabBarDelegate?.minimazeTrackDetailView(self)
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
    
    @IBAction func playPauseTapped(_ sender: Any) {
        if playerIsPlaying {
            reduceTrackImageView()
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            playerTrackPlayPauseButton.setImage(UIImage(named: "play"), for: .normal)
            player.pause()
        } else {
            enlargeTrackImageView()
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            playerTrackPlayPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            player.play()
        }
    }
    
    
    // MARK: - selctor methods
    
    @objc private func handleTapMaximized() {
        self.tabBarDelegate?.maximazeTrackDetailView(withViewModel: nil)
    }
    
    @objc private func handlePanMaximized(gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .changed: handleMinimazedPanChange(gesture: gesture)
        case .ended: handleMinimazedEndGesture(gesture: gesture)
        case .possible: break
        case .began: break
        case .cancelled: break
        case .failed: break
        @unknown default: break
        }
    }
    
    @objc private func handlePanMinimazed(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed: handleMaximizedPanChange(gesture: gesture)
        case .ended: handleMaximizedEndGesture(gesture: gesture)
        case .possible: break
        case .began: break
        case .cancelled: break
        case .failed: break
        @unknown default: break
        }
    }

    
    // MARK: - Public methods
    
    func set(viewModel: SearchViewModel.Cell) {
        playerTrackPlayPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        
        authorLabel.text = viewModel.artistName
        trackTitleLabel.text = viewModel.trackName
        playerTrackTitleLabel.text = viewModel.trackName
        
        let iconUrlString600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        if let urlString = iconUrlString600, let imageUrl = URL(string: urlString) {
            trackImageView.sd_setImage(with: imageUrl, completed: nil)
            playerTrackImageView.sd_setImage(with: imageUrl, completed: nil  )
        }
        
        playTrack(previewUrl: viewModel.previewUrl)
        
    }
    
    
    
    // MARK: - Private methods
    
    private func setupTrackImageView() {
        trackImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        trackImageView.layer.cornerRadius = 7
    }
    
    
    // MARK: - Gestures
    
    private func setupGestues() {
        trackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximized)))
        trackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanMaximized)))
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanMinimazed)))
    }
    
    
    private func handleMinimazedPanChange(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        
        let alpha = 1 + translation.y / 200
        
        trackView.alpha = alpha < 0 ? 0 : alpha
        maximizeStackView.alpha = -translation.y / 200
    }
    
    private func handleMaximizedPanChange(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        
        let alp = translation.y / 500
        trackView.alpha = alp
        maximizeStackView.alpha = 1 - alp
    }
    
    private func handleMinimazedEndGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        
                        self.transform = .identity
                        
                        if translation.y < -200 {
                            self.tabBarDelegate?.maximazeTrackDetailView(withViewModel: nil)
                        } else {
                            self.trackView.alpha = 1
                            self.maximizeStackView.alpha = 0
                        }
        }) { (_) in
    
        }
    }
    
    private func handleMaximizedEndGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut, animations: {
                        
                        self.transform = .identity
                        
                        if translation.y > 300 {
                            self.tabBarDelegate?.minimazeTrackDetailView(self)
                        } else {
                            
                            self.maximizeStackView.alpha = 1
                            self.trackView.alpha = 0
                        }
        }) { (_) in
            
        }
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


// MARK: - Player methods

extension TrackDetailView {
    
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
}
