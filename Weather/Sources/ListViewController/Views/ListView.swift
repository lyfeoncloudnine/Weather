//
//  ListView.swift
//  Weather
//
//  Created by lyfeoncloudnine on 2023/05/24.
//

import UIKit

import Hook
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
