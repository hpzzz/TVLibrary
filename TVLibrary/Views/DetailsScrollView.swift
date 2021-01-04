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
    
    lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.systemBlue, for: .normal)
//        button.addTarget(self, action: #selector(showAllPopular), for: .touchUpInside)
        button.backgroundColor = .clear
        return button
    }()
    
    let redView: UIView = {
        let v = UIView()
        v.backgroundColor = .red
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let greenView: UIView = {
        let v = UIView()
        v.backgroundColor = .green
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let blueView: UIView = {
        let v = UIView()
        v.backgroundColor = .blue
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(backdropImageView)
        self.addSubview(titleLabel)
        self.addSubview(posterImageView)
        self.addSubview(overviewLabel)
        self.addSubview(addButton)
        
        self.addSubview(blueView)

        
        NSLayoutConstraint.activate([
            backdropImageView.heightAnchor.constraint(equalToConstant: 250),
            blueView.heightAnchor.constraint(equalToConstant: 1000),
            ])

        // give each view a width constraint equal to scrollView's width
        NSLayoutConstraint.activate([
            backdropImageView.widthAnchor.constraint(equalTo: self.widthAnchor),
//            titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 150),
            blueView.widthAnchor.constraint(equalTo: self.widthAnchor),
            ])

        // constrain each view's leading and trailing to the scrollView
        // this also defines the width of the scrollView's .contentSize
        NSLayoutConstraint.activate([
            backdropImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            overviewLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            addButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            blueView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            posterImageView.trailingAnchor.constraint(equalTo: self.overviewLabel),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            overviewLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            addButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            blueView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])

        // constrain redView's Top to scrollView's Top + 8-pts padding
        // this also defines the Top of the scrollView's .contentSize
        NSLayoutConstraint.activate([
            backdropImageView.topAnchor.constraint(equalTo: self.topAnchor),
            ])
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            ])

        // constrain greenView's Top to redView's Bottom + 20-pts spacing
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: 8.0),
            ])

        // constrain blueView's Top to greenView's Bottom + 20-pts spacing
        NSLayoutConstraint.activate([
            blueView.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 20.0),
            ])
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20.0),
            ])

        // constrain blueView's Bottom to scrollView's Bottom + 8-pts padding
        // this also defines the Bottom / Height of the scrollView's .contentSize
        // Note: it must be negative
        NSLayoutConstraint.activate([
            blueView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8.0),
            ])
        
//        NSLayoutConstraint.activate([
//            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            addButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//        ])
        
        
//        self.addSubview(posterImageView)
//        self.addSubview(voteAverageLabel)
//        self.addSubview(voteCountLabel)
//        self.addSubview(overviewLabel)
    }
    
    func configureAddButton(_ inLibrary: Bool) {
        addButton.setTitle(inLibrary ? "Remove from Library": "Add to library", for: .normal)
    }
    
    func configure(for details: TVShowDetailsApiResponse) {
        
        if details.name.isEmpty {
            titleLabel.text = "Unknown"
        } else {
            titleLabel.text = details.name
        }
        
        if details.overview.isEmpty {
            overviewLabel.text = "No description"
        } else {
            overviewLabel.text = details.overview
        }
        
        
        voteAverageLabel.text = "★ " + String(details.voteAverage) + "/10"
        voteCountLabel.text = String(details.voteCount)
        
//        backdropImageView.image = UIImage(named: "Placeholder")
        
        
        if let smallURL = URL(string: details.image) {
            backdropImageView.loadImageWithUrl(smallURL)
        }
        
        if let url = URL(string: details.poster) {
            posterImageView.loadImageWithUrl(url)
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
        return imageView
    }()
    
    lazy var backdropImageView: ImageLoader = {
        let imageView = ImageLoader()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 30, weight: .medium))
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
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 18))
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
