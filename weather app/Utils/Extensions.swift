//
//  Extensions.swift
//  WeatherApp
//
//  Created by Stefka Krachunova on 7.08.24.
//

import UIKit

extension WeatherModel {
    static func getWeatherIconType(condition: Int, isNight: Bool) -> (String, UIColor) {
        
        if(isNight && (condition == 0 || condition == 1)) {
            return ("moon.stars", .moon)
        }
        
        switch condition {
        case 0: return ("sun.max", .sun)
        case 1: return ("sun.min", .sun)
        case 2, 3: return ("cloud", .cloud)
        case 45, 48, 49: return ("cloud.fog", .cloud)
        case 50..<54: return ("cloud.drizzle", .cloud)
        case 54..<58, 64..<68: return ("cloud.sleet", .cloud)
        case 60..<64, 80..<83: return ("cloud.rain", .cloud)
        case 70..<74,85, 86: return ("cloud.snow", .cloud)
        case 79: return ("snowflake", .moon)
        case 95: return ("cloud.bolt", .cloud)
        case 96, 99: return ("cloud.bolt.rain", .cloud)
        default: return ("icloud.slash", .moon)
        }
    }
    
    static func parseJson(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherModel.self, from: weatherData)
            
            let lat = decodedData.latitude
            let long = decodedData.longitude
            let hourly = decodedData.hourly
            
            
            return WeatherModel(latitude: lat, longitude: long, hourly: hourly)
            
        } catch {
            print(error)
            return nil
        }
    }
}

extension UIViewController {
    func showAlert(message: String, title: String = "Warning") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension String {
    func toCustomFormattedDate() -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        
        guard let date = inputFormatter.date(from: self) else {
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
        
        let formattedDate = outputFormatter.string(from: date)
        return formattedDate
    }
    
    func isTimeBetweenTenPMAndSevenAM() -> Bool {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"

        guard let date = inputFormatter.date(from: self) else {
            return false
        }
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        return hour >= 22 || hour < 7
    }
}
