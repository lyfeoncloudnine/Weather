//
//  ReusableType.swift
//  Weather
//
//  Created by lyfeoncloudnine on 2023/05/24.
//

import Foundation

protocol ReusableType {
    static var reuseIdentifier: String { get }
}

extension ReusableType {
    static var reuseIdentifier: String { String(describing: self) }
}
