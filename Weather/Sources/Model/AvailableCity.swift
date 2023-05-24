//
//  AvailableCity.swift
//  Weather
//
//  Created by lyfeoncloudnine on 2023/05/24.
//

import Foundation

enum AvailableCity: String {
    case seoul = "Seoul"
    case london = "London"
    case chicago = "Chicago"
    
    var countryCode: String {
        switch self {
        case .seoul:
            return "KR"
            
        case .london:
            return "GB"
            
        case .chicago:
            return "US"
        }
    }
}
