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
    @IBOutlet weak var posterImageView: ImageLoader!
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
//            downloadTask = posterImageView.loadImage(url: smallURL)
            posterImageView.loadImageWithUrl(smallURL)
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
