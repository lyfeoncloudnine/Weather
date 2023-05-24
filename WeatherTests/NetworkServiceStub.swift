//
//  NetworkServiceStub.swift
//  WeatherTests
//
//  Created by lyfeoncloudnine on 2023/05/24.
//

import Foundation

import Moya
import RxMoya
import RxSwift
@testable import Weather

final class NetworkServiceStub: NetworkServiceType {
    private let provider = MoyaProvider<WeatherTarget>(stubClosure: MoyaProvider.immediatelyStub)
    
    func request(_ target: WeatherTarget) -> RxSwift.Observable<Response> {
        provider.rx.request(target).asObservable()
    }
}
