//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Stefka Krachunova on 7.08.24.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
