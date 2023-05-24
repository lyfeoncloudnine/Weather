//
//  WeatherError.swift
//  Weather
//
//  Created by lyfeoncloudnine on 2023/05/24.
//

import Foundation

enum WeatherError: LocalizedError {
    case decodeFail
    
    var errorDescription: String? {
        switch self {
        case .decodeFail:
            return "데이터 디코딩 실패"
        }
    }
}
