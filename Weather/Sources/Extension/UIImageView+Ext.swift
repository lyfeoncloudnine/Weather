//
//  UIImageView+Ext.swift
//  Weather
//
//  Created by lyfeoncloudnine on 2023/05/24.
//

import UIKit

import Kingfisher

extension UIImageView {
    func setImage(from url: String) {
        kf.setImage(
            with: URL(string: url),
            options: [
                .transition(.fade(0.3))
            ]
        )
    }
}
