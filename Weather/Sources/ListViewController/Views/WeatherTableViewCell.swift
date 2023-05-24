//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by lyfeoncloudnine on 2023/05/24.
//

import UIKit

import Hook
import Then

final class WeatherTableViewCell: BaseTableViewCell {
    private let dateLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .subheadline)
    }
    
    private let iconImageView = UIImageView()
    
    private let descriptionLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .body)
    }
    
    private let minTempLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .caption1)
    }
    
    private let maxTempLabel = UILabel().then {
        $0.font = .preferredFont(forTextStyle: .caption1)
    }
    
    override func configureViews() {
        super.configureViews()
        
        contentView.addSubviews(dateLabel, iconImageView, descriptionLabel, minTempLabel, maxTempLabel)
        
        dateLabel.hook
            .top(equalTo: contentView.topAnchor, constant: 8)
            .leading(equalTo: contentView.leadingAnchor, constant: 8)
        
        iconImageView.hook
            .top(equalTo: dateLabel.bottomAnchor, constant: 8)
            .leading(equalTo: dateLabel.leadingAnchor)
            .bottom(equalTo: contentView.bottomAnchor, constant: -8)
            .width(equalToConstant: 40)
            .height(equalToConstant: 40)
        
        descriptionLabel.hook
            .leading(equalTo: iconImageView.trailingAnchor, constant: 8)
            .centerY(to: iconImageView.centerYAnchor)
        
        minTempLabel.hook
            .trailing(equalTo: maxTempLabel.leadingAnchor, constant: -4)
            .centerY(to: iconImageView.centerYAnchor)
        
        maxTempLabel.hook
            .trailing(equalTo: contentView.trailingAnchor, constant: -8)
            .centerY(to: iconImageView.centerYAnchor)
    }
}

extension WeatherTableViewCell {
    func configure(with weather: Weather) {
        dateLabel.text = weather.date.formatted(date: .long, time: .omitted)
        iconImageView.setImage(from: iconURLString(weather.icon))
        descriptionLabel.text = weather.description
        minTempLabel.text = "Min: \(weather.minTemp)°C"
        maxTempLabel.text = "Max: \(weather.maxTemp)°C"
    }
}

extension WeatherTableViewCell {
    func iconURLString(_ icon: String) -> String {
        "https://openweathermap.org/img/wn/\(icon)@2x.png"
    }
}
