//
//  NetworkServiceType.swift
//  Weather
//
//  Created by lyfeoncloudnine on 2023/05/24.
//

import Foundation

import Moya
import RxSwift

protocol NetworkServiceType {
    func request(_ target: TargetType) -> Observable<Response>
}
