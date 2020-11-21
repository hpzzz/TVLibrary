//
//  SectionHeader.swift
//  TVLibrary
//
//  Created by Karol Harasim on 09/05/2020.
//  Copyright © 2020 Karol Harasim. All rights reserved.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeader"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleLabel)
        self.addSubview(seeAll)
        
        NSLayoutConstraint.activate([
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
        seeAll.topAnchor.constraint(equalTo: topAnchor, constant: 10),
        seeAll.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
        
    }
    

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.numberOfLines = 2
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 20, weight: .bold))
        return label
     }()

    
    lazy var seeAll: UIButton = {
        let button  = UIButton(type: .system)
        button.setTitle("See all", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(showAllPopular), for: .touchUpInside)
        button.backgroundColor = .clear
        return button
    }()
    
    @objc fileprivate func showAllPopular(){
        //
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
