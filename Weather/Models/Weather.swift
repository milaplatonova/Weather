//
//  Weather.swift
//  Weather
//
//  Created by Lyudmila Platonova on 7.10.21.
//

import Foundation

struct Weather {
    var city: String
    var timeZone: Int
    var weatherID: Int
    var weatherDescription: String
    var temperature: Int
    var sunrise: Date
    var sunset: Date
    var cloudiness: Int
    var wind: Double
    var pressure: Int
    
    init (city: String, timeZone: Int, weatherID: Int, weatherDescription: String, temperature: Int, sunrise: Date, sunset: Date, cloudiness: Int, wind: Double, pressure: Int) {
        self.city = city
        self.timeZone = timeZone
        self.weatherID = weatherID
        self.weatherDescription = weatherDescription
        self.temperature = temperature
        self.sunrise = sunrise
        self.sunset = sunset
        self.cloudiness = cloudiness
        self.wind = wind
        self.pressure = pressure
    }
    
    func relevantDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: self.timeZone)
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }
    
}

