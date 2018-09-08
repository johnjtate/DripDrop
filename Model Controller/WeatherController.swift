//
//  WeatherController.swift
//  DripDrop
//
//  Created by John Tate on 9/8/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherController {
    
    static let shared = WeatherController()
    // no other class can initialize it
    private init() {}
    
    var dailyWeathers: [DailyWeather]?
    var currentWeather: CurrentWeather?
    
    let locationManager = CLLocationManager()
    
    let baseURL = URL(string: "https://api.darksky.net/forecast/")
    let apiSecret = "11b3c3f92316ff9604ba6718db92b40a"
    
    func fetchWeeklyWeather(latitude: Double, longitude: Double, completion: @escaping (([DailyWeather]?) -> Void)) {
    
        // 1) Getting your URL right
        // We need to unwrap the baseURL because the URL(string: String) initializer is failable
        guard let baseURL = baseURL else { completion(nil) ; return }
        var url = baseURL.appendingPathComponent(apiSecret)
        url.appendPathComponent("\(latitude),\(longitude)")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: "exclude", value: "[minutely,hourly,alerts,flags]")]
        
        guard let finishedUrl = components?.url else { completion(nil); return }
    
        print(finishedUrl.absoluteString)
    
        // 2) Calling the DataTask step
    
        
        URLSession.shared.dataTask(with: finishedUrl) { (data, response, error) in
            
            if let error = error {
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            
            print("\(response ?? URLResponse())")
            
            guard let data = data else { completion(nil); return }
            
            // 2.5) Decoding your data
            let decoder = JSONDecoder()
            do {
                let weatherService = try decoder.decode(WeatherService.self, from: data)
                let dailyWeathers = weatherService.weeklyWeatherData.data
                self.dailyWeathers = dailyWeathers
                self.currentWeather = weatherService.currently
                completion(dailyWeathers)
                
            } catch {
                print("There was an error in \(#function) : \(error) \(error.localizedDescription)")
                completion(nil)
            }
            // Make sure you put .resume()
        }.resume()
        
    
    }
}
