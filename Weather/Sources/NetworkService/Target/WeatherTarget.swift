//
//  WeatherTarget.swift
//  Weather
//
//  Created by lyfeoncloudnine on 2023/05/24.
//

import Foundation

import Moya

enum WeatherTarget {
    case geocoding(city: AvailableCity)
    case forecast(city: City)
}

extension WeatherTarget: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://api.openweathermap.org/") else { fatalError("Invalid URL") }
        return url
    }
    
    var path: String {
        switch self {
        case .geocoding:
            return "geo/1.0/direct"
            
        case .forecast:
            return "data/3.0/onecall"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .geocoding, .forecast:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .geocoding(let availableCity):
            return .requestParameters(parameters: ["q": "\(availableCity.rawValue),\(availableCity.countryCode)", "appid": appID], encoding: URLEncoding.default)
            
        case .forecast(let city):
            return .requestParameters(parameters: ["lat": city.lat, "lon": city.lon, "exclude": "current,minutely,hourly,alert", "units": "metric", "appid": appID], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        nil
    }
}

extension WeatherTarget {
    var appID: String {
        "0381e9354fe50a3a0a5fa63b9f067c8d"
    }
}

extension WeatherTarget {
    var sampleData: Data {
        switch self {
        case .geocoding:
            guard let path = Bundle.main.path(forResource: "GeocodingMock", ofType: "json") else { return Data() }
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return Data() }
            return data
            
        case .forecast:
            guard let path = Bundle.main.path(forResource: "ForecastMock", ofType: "json") else { return Data() }
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return Data() }
            return data
        }
    }
}
