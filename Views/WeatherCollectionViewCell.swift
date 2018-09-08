//
//  WeatherCollectionViewCell.swift
//  DripDrop
//
//  Created by John Tate on 9/8/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var dayOfTheWeekLabel: UILabel!
    
    // landing pad
    var dailyWeather: DailyWeather? {
        didSet {
            updateView()
        }
    }
    
    func stringFromTime(time: TimeInterval) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        
        let date = Date(timeIntervalSince1970: time)
        
        return formatter.string(from: date)
    }
    
    func updateView() {
        guard let dailyWeather = dailyWeather else { return }
        summaryLabel.text = dailyWeather.summary
        dayOfTheWeekLabel.text = stringFromTime(time: dailyWeather.time)
        iconImageView.image = UIImage(named: dailyWeather.icon) ?? UIImage(named: "cloudy")
        iconImageView.layer.shadowOffset = CGSize(width: 1, height: 1)
        iconImageView.layer.shadowRadius = 2.0
        iconImageView.layer.shadowOpacity = 0.8
        tempLabel.text = "\(Int(dailyWeather.temperatureMax + dailyWeather.temperatureMin)/2)℉"
    }
}
