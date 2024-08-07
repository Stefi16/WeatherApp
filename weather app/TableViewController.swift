//
//  ViewController.swift
//  weather app
//
//  Created by Stefka Krachunova on 7.08.24.
//

import UIKit

class TableViewController: UITableViewController {
    
    var weatherApi = WeatherApiService()
    var weatherModel: WeatherModel?
    let defaults = UserDefaults.standard
    
    private var clickedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        weatherApi.delegate = self
        
        let cachedCityId = defaults.integer(forKey: Constants.selectedCityKey)
        let city = Constants.allCities.first(where: {$0.id == cachedCityId}) ?? Constants.sofiaCityModel
        changeCity(city)
        
        tableView.register(UINib(nibName: Constants.cellName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
    }
    
    private func changeCity(_ city: CityModel) {
        weatherApi.fetchCurrentLocationWeather(lat: city.latitude, lon: city.longitude)
        navigationItem.title = city.name
        
        defaults.set(city.id, forKey: Constants.selectedCityKey)
        defaults.synchronize()
    }
    
    
    @IBAction func onChangeLocationTap(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Select Available Cities", message: nil, preferredStyle: .actionSheet)
        
        for city in Constants.allCities {
            let action = UIAlertAction(title: city.name, style: .default) { [weak self] _ in
                self?.changeCity(city)
            }
            
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.detailsSegue {
            let destinationVc = segue.destination as! DetailedWeatherViewController
            
            destinationVc.hourlyData = weatherModel?.hourly
            destinationVc.index = clickedIndex
        }
    }
}


//MARK: Weather delegate
extension TableViewController: WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel) {
        weatherModel = weather
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(_ error: any Error) {
        showAlert(message: error.localizedDescription)
    }
}

//MARK: TableViewData
extension TableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherModel?.hourly.weatherCode.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hourly = weatherModel?.hourly
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! WeatherTableViewCell
        
        if let safeHourly = hourly {
            let time = safeHourly.time[indexPath.row]
            let temperature = safeHourly.temperature[indexPath.row]
            let conditionId = safeHourly.weatherCode[indexPath.row]
            let windSpeed = safeHourly.windSpeed[indexPath.row]
            
            cell.time.text = time.toCustomFormattedDate()
            cell.temperature.text = "\(temperature) °C"
            
            let imageResult = WeatherModel.getWeatherIconType(condition: conditionId, isNight: time.isTimeBetweenTenPMAndSevenAM())
            cell.weatherIcon.image = UIImage(systemName: imageResult.0)
            cell.weatherIcon.tintColor = imageResult.1
            
            cell.windSpeed.text = "\(windSpeed) km/h"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if weatherModel == nil {
            return
        }
        
        clickedIndex = indexPath.row
        self.performSegue(withIdentifier: Constants.detailsSegue, sender: self)
    }
}
