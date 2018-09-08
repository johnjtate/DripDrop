//
//  WeatherViewController.swift
//  DripDrop
//
//  Created by John Tate on 9/8/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    // computed property with a property observer
    var currentLocation: CLLocation? {
        didSet{
            fetchWeather()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WeatherController.shared.dailyWeathers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as? WeatherCollectionViewCell
        let dailyWeather = WeatherController.shared.dailyWeathers?[indexPath.row]
        cell?.dailyWeather = dailyWeather
        return cell ?? UICollectionViewCell()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherCollectionView.dataSource = self
        weatherCollectionView.delegate = self
        fetchWeather()
        
//        if CLLocationManager.locationServicesEnabled() {
//            // We have to set the delegate
//            WeatherController.shared.locationManager.delegate = self
//            WeatherController.shared.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
//        }
    }
    
    func updateCurrentWeather() {
        guard let currentWeather = WeatherController.shared.currentWeather else { return }
        cityLabel.text = "Salt Lake City"
        summaryLabel.text = currentWeather.summary
        temperatureLabel.text = "\(Int(currentWeather.temperature))℉" 
    }
    
    func fetchWeather() {
//        guard let latitude = currentLocation?.coordinate.latitude,
//        let longitude = currentLocation?.coordinate.longitude else { return }
        WeatherController.shared.fetchWeeklyWeather(latitude: 40.7608, longitude: -111.8910) { (dailyWeathers) in
            DispatchQueue.main.async {
                self.weatherCollectionView.reloadData()
                self.updateCurrentWeather()
            }
        }
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        currentLocation = locations.first
//    }

    
}
