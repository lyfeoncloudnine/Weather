//
//  ListViewController.swift
//  Weather
//
//  Created by lyfeoncloudnine on 2023/05/24.
//

import UIKit

import ReactorKit
import RxSwift

final class ListViewController: UIViewController, View {
    let mainView = ListView()
    
    var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    func bind(reactor: ListViewReactor) {
        // Action
        Observable.just(())
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        mainView.tableView.refreshControl?.rx.controlEvent(.valueChanged)
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        let seoulWeathers = reactor.state.compactMap { $0.seoulWeathers }.distinctUntilChanged()
        let londonWeathers = reactor.state.compactMap { $0.londonWeathers }.distinctUntilChanged()
        let chicagoWeathers = reactor.state.compactMap { $0.chicagoWeathers }.distinctUntilChanged()
        Observable.combineLatest([seoulWeathers, londonWeathers, chicagoWeathers])
            .map { array -> [SectionOfWeather] in
                array.flatMap { $0 }
            }
            .asDriver(onErrorJustReturn: [])
            .drive(mainView.tableView.rx.items(dataSource: mainView.dataSources()))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .do(onNext: { [weak self] in
                if $0 == false && self?.mainView.tableView.refreshControl?.isRefreshing == true {
                    self?.mainView.tableView.refreshControl?.endRefreshing()
                }
            })
            .filter { [weak self] _ in
                return self?.mainView.tableView.refreshControl?.isRefreshing == false
            }
            .asDriver(onErrorJustReturn: false)
            .drive(mainView.loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.title }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        // Pulse
        reactor.pulse(\.$errorMessage)
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, errorMessage in
                weakSelf.presentAlert(message: errorMessage)
            })
            .disposed(by: disposeBag)
    }
}

private extension ListViewController {
    func presentAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(.init(title: "확인", style: .default))
        present(alertController, animated: true)
    }
}
