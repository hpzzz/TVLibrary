//
//  SearchResultCell.swift
//  TVLibrary
//
//  Created by Karol Harasim on 22/10/2020.
//  Copyright © 2020 Karol Harasim. All rights reserved.
//

import Foundation
import UIKit

class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var voteAverageLabel: UILabel!
    
    
    var downloadTask: URLSessionDownloadTask?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
    }

    func configure(for result: SearchResult) {
        
        if result.name.isEmpty {
            nameLabel.text = "Unknown"
        }

        nameLabel.text = result.name
        voteAverageLabel.text = "★ " + String(result.voteAverage)
        

        posterImageView.image = UIImage(named: "Placeholder")
        if let smallURL = URL(string: result.image) {
            downloadTask = posterImageView.loadImage(url: smallURL)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let selectedView = UIView(frame: CGRect.zero)
//        selectedView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
        selectedBackgroundView = selectedView
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    

    
}


//        posterImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
//        posterImageView.rightAnchor.constraint(equalTo: self.nameLabel.leftAnchor, constant: 8).isActive = true
//        posterImageView.rightAnchor.constraint(equalTo: self.voteAverageLabel.leftAnchor, constant: 8).isActive = true
//        posterImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
//        posterImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
//        posterImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
//        posterImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
//
//        nameLabel.leftAnchor.constraint(equalTo: posterImageView.rightAnchor).isActive = true
//        nameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
//        nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
//        nameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
//
//        voteAverageLabel.leftAnchor.constraint(equalTo: posterImageView.rightAnchor).isActive = true
//        voteAverageLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
//        voteAverageLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor).isActive = true
//        voteAverageLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true

//
//    lazy var voteAverageLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    lazy var posterImageView: ImageLoader = {
//        let imageView = ImageLoader()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .scaleAspectFill
//        imageView.backgroundColor = .clear
//        imageView.clipsToBounds = true
//        return imageView
//    }()
//
//    lazy var nameLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = .label
//        return label
//    }()
//
