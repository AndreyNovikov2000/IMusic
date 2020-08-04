//
//  FooterView.swift
//  IMusic
//
//  Created by Andrey Novikov on 8/4/20.
//  Copyright © 2020 Andrey Novikov. All rights reserved.
//

import UIKit

class FooterView: UIView {
    
    // MARK: - Private properties
    
    private let myLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    private let loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        return loader
    }()
    
    // MARK: - Live cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraintsForElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func showLoader() {
        loader.startAnimating()
        myLabel.text = "Loading..."
    }
    
    func hideLoader() {
        loader.stopAnimating()
        myLabel.text = ""
    }
    
    // MARK: - Private methods
    
    private func setupConstraintsForElements() {
        addSubview(myLabel)
        addSubview(loader)
        
        loader.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        loader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        loader.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        myLabel.topAnchor.constraint(equalTo: loader.bottomAnchor, constant: 10).isActive = true
        myLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
