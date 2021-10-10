//
//  NetworkingManager.swift
//  Weather
//
//  Created by Lyudmila Platonova on 7.10.21.
//

import Alamofire


class NetworkingManager {
    
    static let shared = NetworkingManager()

    var currentWeather: Weather?
    var error = 0
    
    
    func getWeather(city: String) {
        var weather = Weather(city: "", timeZone: 0, weatherID: 0, weatherDescription: "", temperature: 0, sunrise: Date(), sunset: Date(), cloudiness: 0, wind: 0.0, pressure: 0)
        let parameters: [String: Any] = ["q": city, "appid": "437a888a929a2675aab668f9c2adcd72"]
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather") else { return }
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let status = response.response?.statusCode {
                guard status == 200 else {
                    self.error = status
                    return
                }
                self.error = 0
                if let data = response.data {
                    print (data)
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                        guard let json = jsonObject as? [String:Any] else { return }
                        print (jsonObject)
                        
                        if let city = json["name"] as? String {
                            weather.city = city
                        }
                        
                        if let currentWeather = json["weather"] as? [[String:Any]] {
                            let weatherDictionary = currentWeather[0]
                            if let description = weatherDictionary["description"] as? String, let id = weatherDictionary["id"] as? Int {
                                weather.weatherDescription = description
                                weather.weatherID = id
                            }
                        }
                        
                        if let timeZone = json["timezone"] as? Int {
                            weather.timeZone = timeZone
                        }
                        
                        if let sysDictionary = json["sys"] as? [String: Any] {
                            if let sunrise = sysDictionary["sunrise"] as? Int, let sunset = sysDictionary["sunset"] as? Int {
                                weather.sunrise = Date(timeIntervalSince1970: TimeInterval(sunrise))
                                weather.sunset = Date(timeIntervalSince1970: TimeInterval(sunset))
                            }
                        }
                        
                        if let mainDictionary = json["main"] as? [String: Any] {
                            if let temp = mainDictionary["temp"] as? Double, let pressure = mainDictionary["pressure"] as? Int {
                                weather.temperature = Int(temp - 273)
                                weather.pressure = pressure
                            }
                        }
                        
                        if let windDictionary = json["wind"] as? [String: Any] {
                            if let speed = windDictionary["speed"] as? Double {
                                weather.wind = speed
                            }
                        }
                        
                        if let cloudsDictionary = json["clouds"] as? [String: Any] {
                            if let all = cloudsDictionary["all"] as? Int {
                                weather.cloudiness = all
                            }
                        }
                        
                        self.currentWeather = weather
                        
                    } catch (let exception) {
                        print (exception)
                    }
                }
            }
        }
    }
}

