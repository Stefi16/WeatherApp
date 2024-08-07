//
//  DetailedWeatherViewController.swift
//  WeatherApp
//
//  Created by Stefka Krachunova on 7.08.24.
//

import UIKit

class DetailedWeatherViewController: UIViewController {
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    private let defaults = UserDefaults.standard
    
    var hourlyData: HourlyData?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cachedCityId = defaults.integer(forKey: Constants.selectedCityKey)
        let city = Constants.allCities.first(where: {$0.id == cachedCityId}) ?? Constants.sofiaCityModel
        
        cityName.text = "\(city.name)"
        
        guard let hourly = hourlyData, let clickedIndex = index else {
            return
        }
        
        let time = hourly.time[clickedIndex]
        let temperature = hourly.temperature[clickedIndex]
        let conditionId = hourly.weatherCode[clickedIndex]
        let windSpeed = hourly.windSpeed[clickedIndex]
        
        timeLabel.text = time.toCustomFormattedDate()
        temperatureLabel.text = "\(temperature) °C"
        
        let imageResult = WeatherModel.getWeatherIconType(condition: conditionId, isNight: time.isTimeBetweenTenPMAndSevenAM())
        weatherIcon.image = UIImage(systemName: imageResult.0)
        
        windLabel.text = "\(windSpeed) km/h"
    }
}
