//
//  ListView.swift
//  Weather
//
//  Created by lyfeoncloudnine on 2023/05/24.
//

import UIKit

import Hook
import RxDataSources
import Then

final class ListView: BaseView {
    let tableView = UITableView().then {
        $0.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.reuseIdentifier)
        $0.refreshControl = UIRefreshControl()
    }
    
    let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    override func configureViews() {
        super.configureViews()
        
        addSubviews(tableView, loadingIndicator)
        
        tableView.hook.all(to: self, safeAreaSides: [.top])
        
        loadingIndicator.hook.all(to: self)
    }
}

extension ListView {
    func dataSources() -> RxTableViewSectionedAnimatedDataSource<SectionOfWeather> {
        RxTableViewSectionedAnimatedDataSource(
            animationConfiguration: .init(insertAnimation: .fade, reloadAnimation: .fade, deleteAnimation: .fade),
            configureCell: { _, tableView, indexPath, weather in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.reuseIdentifier, for: indexPath) as? WeatherTableViewCell else { return UITableViewCell() }
                cell.configure(with: weather)
                return cell
            },
            titleForHeaderInSection: { dataSource, section in
                dataSource[section].header
            }
        )
    }
}
