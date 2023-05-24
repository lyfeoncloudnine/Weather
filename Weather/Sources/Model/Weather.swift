//
//  Weather.swift
//  Weather
//
//  Created by lyfeoncloudnine on 2023/05/24.
//

import Foundation

struct Weather: Decodable, Equatable {
    let date: Date
    let minTemp: Double
    let maxTemp: Double
    let description: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case temp
        case weather
    }
    
    struct Temp: Decodable {
        let min: Double
        let max: Double
    }
    
    struct WeatherDetail: Decodable {
        let description: String
        let icon: String
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(Date.self, forKey: .date)
        
        let temp = try container.decode(Temp.self, forKey: .temp)
        minTemp = temp.min
        maxTemp = temp.max
        
        guard let detail = (try container.decode([WeatherDetail].self, forKey: .weather)).first else { throw WeatherError.decodeFail }
        description = detail.description
        icon = detail.icon
    }
}

enum WeatherError: LocalizedError {
    case decodeFail
    
    var errorDescription: String? {
        switch self {
        case .decodeFail:
            return "데이터 디코딩 실패"
        }
    }
}
