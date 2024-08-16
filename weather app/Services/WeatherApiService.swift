//
//  ApiService.swift
//  weather app
//
//  Created by Stefka Krachunova on 7.08.24.
//

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(_ error: Error)
}

import Foundation

struct WeatherApiService {
    private let session = URLSession(configuration: .default)
    private let url = "https://api.open-meteo.com/v1/"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchCurrentLocationWeather(lat: Double, lon: Double) {
        let urlString = "\(url)forecast?latitude=\(lat)&longitude=\(lon)&hourly=temperature_2m,weathercode,windspeed_10m"
        
        performRequest(with: urlString)
    }
    
    private func performRequest(with url: String) {
        
        let url = URL(string: url)
        
        if let safeUrl = url {
            let task = session.dataTask(with: safeUrl) { data, response, error in
                if let safeData = data {
                    if let weatherResult = WeatherModel.parseJson(safeData) {
                        self.delegate?.didUpdateWeather(weather: weatherResult)
                    }
                }
                
                if let safeError = error {
                    delegate?.didFailWithError(safeError)
                }
                
            }
            
            task.resume()
        }
    }
}
