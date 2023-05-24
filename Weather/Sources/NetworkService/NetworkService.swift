//
//  NetworkService.swift
//  Weather
//
//  Created by lyfeoncloudnine on 2023/05/24.
//

import Foundation

import Moya
import RxMoya
import RxSwift

final class NetworkService: NetworkServiceType {
    private let provider = MoyaProvider<WeatherTarget>()
    
    func request(_ target: WeatherTarget) -> RxSwift.Observable<Response> {
        provider.rx.request(target).asObservable()
    }
}
