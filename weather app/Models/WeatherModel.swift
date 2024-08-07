//
//  WeatherModel.swift
//  weather app
//
//  Created by Stefka Krachunova on 7.08.24.
//

import Foundation

struct WeatherModel: Codable {
    let latitude: Double
    let longitude: Double
    let hourly: HourlyData
}

struct HourlyData: Codable {
    let time: [String]
    let temperature: [Double]
    let weatherCode: [Int]
    let windSpeed: [Double]
    
    enum CodingKeys: String, CodingKey {
        case time
        case temperature = "temperature_2m"
        case weatherCode = "weathercode"
        case windSpeed = "windspeed_10m"
    }
}
