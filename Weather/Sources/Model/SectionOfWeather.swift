//
//  SectionOfWeather.swift
//  Weather
//
//  Created by lyfeoncloudnine on 2023/05/24.
//

import Foundation

import RxDataSources

extension Weather: IdentifiableType {
    var identity: String { UUID().uuidString }
}

struct SectionOfWeather {
    let header: String
    var items: [Item]
}

extension SectionOfWeather: AnimatableSectionModelType, Equatable {
    typealias Item = Weather
    
    var identity: String { header }
    
    init(original: SectionOfWeather, items: [Weather]) {
        self = original
        self.items = items
    }
}
