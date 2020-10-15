//
//  PopularCell.swift
//  TVLibrary
//
//  Created by Karol Harasim on 06/05/2020.
//  Copyright © 2020 Karol Harasim. All rights reserved.
//

import UIKit


class PopularCell: UICollectionViewCell, SelfConfiguringCell {
    static var reuseIdentifier: String = "PopularCell"
    var downloadTask: URLSessionDownloadTask?
    var popular: TVShow?
    
    lazy var imageView: ImageLoader = {
        let imageView = ImageLoader()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
//        label.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 20, weight: .bold))
        label.numberOfLines = 2
        return label
     }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
        func configure(with TVShow: TVShow) {
            titleLabel.text = TVShow.name
            if let smallURL = URL(string: "https://image.tmdb.org/t/p/w300/\(TVShow.posterPath)") {
                imageView.loadImageWithUrl(smallURL)
            }
            contentView.addSubview(imageView)
            contentView.addSubview(titleLabel)
            
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                imageView.heightAnchor.constraint(equalTo: self.widthAnchor,multiplier: (3/2)),
                
                titleLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                titleLabel.heightAnchor.constraint(equalToConstant: 50)
                ])
        }
    
}
