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
        let processor = DownsamplingImageProcessor(size: bounds.size)
        kf.setImage(
            with: URL(string: url),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.3))
            ]
        )
    }
}
