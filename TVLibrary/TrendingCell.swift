//
//  TrendingCell.swift
//  TVLibrary
//
//  Created by Karol Harasim on 06/04/2020.
//  Copyright © 2020 Karol Harasim. All rights reserved.
//

import UIKit

class TrendingCell: UICollectionViewCell, SelfConfiguringCell {
    static var reuseIdentifier: String = "TrendingCell"
    var downloadTask: URLSessionDownloadTask?
    var trending: TVShow?

    
    lazy var imageView: ImageLoader = {
        let imageView = ImageLoader()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.gray.cgColor
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 20, weight: .bold))
        label.numberOfLines = 2
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func configure(with TVShow: TVShow) {
        titleLabel.text = TVShow.name
        if let smallURL = URL(string: "https://image.tmdb.org/t/p/w300/\(TVShow.backdropPath)") {
            imageView.loadImageWithUrl(smallURL)
        }
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1),
//            imageView.topAnchor.constraint(equalTo: self.topAnchor),
//                imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//                imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//                imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    

    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}

