//
//  ListViewReactorTests.swift
//  WeatherTests
//
//  Created by lyfeoncloudnine on 2023/05/24.
//

import XCTest

import RxSwift
import RxTest
import Quick
@testable import Weather

final class ListViewReactorTests: QuickSpec {
    override class func spec() {
        var networkService: NetworkServiceType!
        var reactor: ListViewReactor!
        
        beforeEach {
            networkService = NetworkServiceStub()
            reactor = ListViewReactor(networkService: networkService)
        }
        
        afterEach {
            networkService = nil
            reactor = nil
        }
        
        context("로드하지 않았을 때") {
            it("각 날씨는 비어있다") {
                XCTAssertNil(reactor.currentState.seoulWeathers)
                XCTAssertNil(reactor.currentState.londonWeathers)
                XCTAssertNil(reactor.currentState.chicagoWeathers)
            }
            
            it("로딩중이 아니다") {
                XCTAssertFalse(reactor.currentState.isLoading)
            }
            
            it("에러메시지는 없다") {
                XCTAssertNil(reactor.currentState.errorMessage)
            }
        }
        
        context("로드했을 떄") {
            context("성공하면") {
                it("각 날씨는 비어있지 않다") {
                    reactor.action.onNext(.refresh)
                    XCTAssertNotNil(reactor.currentState.seoulWeathers)
                    XCTAssertNotNil(reactor.currentState.londonWeathers)
                    XCTAssertNotNil(reactor.currentState.chicagoWeathers)
                }
            }
            
            context("실패하면") {
                it("에러메시지가 있다") {
                    reactor.isStubEnabled = true
                    reactor.stub.state.value = ListViewReactor.State(errorMessage: "대충 에러메시지")
                    XCTAssertNotNil(reactor.currentState.errorMessage)
                }
            }
        }
    }
}
