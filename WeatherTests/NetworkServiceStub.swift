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
    
    private let failure: Bool
    
    init(failure: Bool = false) {
        self.failure = failure
    }
    
    func request(_ target: WeatherTarget) -> RxSwift.Observable<Response> {
        if failure {
            return .just(Response(statusCode: 200, data: Data()))
        } else {
            return provider.rx.request(target).asObservable()
        }
    }
}
