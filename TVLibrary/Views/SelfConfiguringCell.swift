//
//  SelfConfiguringCell.swift
//  TVLibrary
//
//  Created by Karol Harasim on 10/04/2020.
//  Copyright © 2020 Karol Harasim. All rights reserved.
//

import Foundation


protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
    func configure(with: TVShowPreview)
}
