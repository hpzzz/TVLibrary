//
//  DetailsView.swift
//  TVLibrary
//
//  Created by Karol Harasim on 09/12/2020.
//  Copyright © 2020 Karol Harasim. All rights reserved.
//

import UIKit

class DetailsScrollView: UIScrollView {
    var downloadTask: URLSessionDownloadTask?
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .yellow
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        
        stackView.addSubview(backdropImageView)
        
        
//        self.addSubview(posterImageView)
//        self.addSubview(backdropImageView)
        
//        self.addSubview(titleLabel)
//        self.addSubview(voteAverageLabel)
//        self.addSubview(voteCountLabel)
//        self.addSubview(overviewLabel)
//
        

        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backdropImageView.topAnchor.constraint(equalTo: topAnchor),
            backdropImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
            
        ])
    }
    
    func configure(for details: TVShowDetailsApiResponse) {
        
        if details.name.isEmpty {
            titleLabel.text = "Unknown"
        } else {
            titleLabel.text = details.name
        }
        
        voteAverageLabel.text = "★ " + String(details.voteAverage) + "/10"
        voteCountLabel.text = String(details.voteCount)
        
//        backdropImageView.image = UIImage(named: "Placeholder")
        if let smallURL = URL(string: details.image) {
            downloadTask = backdropImageView.loadImage(url: smallURL)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    lazy var posterImageView: ImageLoader = {
        let imageView = ImageLoader()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1.0
        return imageView
    }()
    
    lazy var backdropImageView: ImageLoader = {
        let imageView = ImageLoader()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1.0
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 20, weight: .bold))
        label.numberOfLines = 2
        return label
    }()
    
    lazy var voteAverageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 20, weight: .bold))
        label.numberOfLines = 2
        return label
    }()
    
    lazy var voteCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 20, weight: .bold))
        label.numberOfLines = 2
        return label
    }()
    
    lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 20, weight: .bold))
        label.numberOfLines = 0
        return label
    }()
    
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
