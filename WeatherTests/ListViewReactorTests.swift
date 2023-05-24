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
        describe("ListViewReactorTests") {
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
                    XCTAssertTrue(reactor.currentState.seoulWeathers.isEmpty)
                    XCTAssertTrue(reactor.currentState.londonWeathers.isEmpty)
                    XCTAssertTrue(reactor.currentState.chicagoWeathers.isEmpty)
                }
                
                it("로딩중이 아니다") {
                    XCTAssertFalse(reactor.currentState.isLoading)
                }
                
                it("에러메시지는 없다") {
                    XCTAssertNil(reactor.currentState.errorMessage)
                }
            }
            
            context("로드했을 때") {
                context("성공하면") {
                    beforeEach {
                        reactor.action.onNext(.refresh)
                    }
                    
                    it("각 날씨는 존재한다") {
                        XCTAssertFalse(reactor.currentState.seoulWeathers.isEmpty)
                        XCTAssertFalse(reactor.currentState.londonWeathers.isEmpty)
                        XCTAssertFalse(reactor.currentState.chicagoWeathers.isEmpty)
                    }
                    
                    it("에러메시지는 없다") {
                        XCTAssertNil(reactor.currentState.errorMessage)
                    }
                }
                
                context("실패하면") {
                    beforeEach {
                        networkService = NetworkServiceStub(failure: true)
                        reactor = ListViewReactor(networkService: networkService)
                        reactor.action.onNext(.refresh)
                    }
                    
                    it("각 날씨는 비어있다") {
                        XCTAssertTrue(reactor.currentState.seoulWeathers.isEmpty)
                        XCTAssertTrue(reactor.currentState.londonWeathers.isEmpty)
                        XCTAssertTrue(reactor.currentState.chicagoWeathers.isEmpty)
                    }
                    
                    it("에러메시지가 존재한다") {
                        XCTAssertNotNil(reactor.currentState.errorMessage)
                    }
                }
                
                it("로딩 상태는 변한다") {
                    let scheduler = TestScheduler(initialClock: 0)
                    let disposeBag = DisposeBag()
                    
                    scheduler.scheduleAt(10) {
                        reactor.action.onNext(.refresh)
                    }
                    
                    let observer = scheduler.createObserver(Bool.self)
                    reactor.state.map { $0.isLoading }
                        .distinctUntilChanged()
                        .subscribe(observer)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                    
                    let expectedEvents: [Recorded<Event<Bool>>] = [
                        .next(0, false),
                        .next(10, true),
                        .next(10, false)
                    ]
                    
                    XCTAssertEqual(observer.events, expectedEvents)
                }
            }
        }
    }
}
