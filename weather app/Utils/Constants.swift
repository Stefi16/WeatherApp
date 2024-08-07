//
//  Constants.swift
//  weather app
//
//  Created by Stefka Krachunova on 7.08.24.
//

import Foundation

struct Constants {
    //MARK: City models
    static let sofiaCityModel: CityModel = CityModel(id: 0, name: "Sofia", latitude: 42.70, longitude: 23.32)
    static let plovdivCityModel: CityModel = CityModel(id: 1, name: "Plovdiv", latitude: 42.15, longitude: 24.75)
    static let burgasCityModel: CityModel = CityModel(id: 2, name: "Burgas", latitude: 42.51, longitude: 27.47)
    static let allCities = [sofiaCityModel, plovdivCityModel, burgasCityModel]
    
    //MARK: Cells
    static let cellIdentifier = "ReusableCell"
    static let cellName = "WeatherTableViewCell"
    
    //MARK: User defaults key
    static let selectedCityKey = "SelectedCityKey"
    
    //MARK: Segues
    static let detailsSegue = "DetailsWeatherSegue"
}
