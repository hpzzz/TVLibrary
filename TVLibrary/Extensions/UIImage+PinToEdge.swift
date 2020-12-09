//
//  UIImage+PinToEdge.swift
//  TVLibrary
//
//  Created by Karol Harasim on 09/12/2020.
//  Copyright © 2020 Karol Harasim. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func pinEdges(to other: UIView) {
        leadingAnchor.constraint(equalTo: other.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor).isActive = true
    }
}
