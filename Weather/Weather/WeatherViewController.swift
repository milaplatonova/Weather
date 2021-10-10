//
//  WeatherViewController.swift
//  Weather
//
//  Created by Lyudmila Platonova on 7.10.21.
//

import UIKit


class WeatherViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var cloudinessLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
   
    @IBOutlet var weatherImages: [UIImageView]!
    
    var weather: Weather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weather = NetworkingManager.shared.currentWeather
        for subview in self.view.subviews {
            subview.alpha = 0
        }
        
        view.layer.configureGradientBackground(#colorLiteral(red: 0.7624265729, green: 0.9234973021, blue: 1, alpha: 1), #colorLiteral(red: 0.5810806817, green: 0.7652670621, blue: 0.8225850578, alpha: 1), #colorLiteral(red: 0.1871025008, green: 0.4948214765, blue: 0.6487688043, alpha: 1))
        
        for image in weatherImages {
            image.layer.cornerRadius = 25
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let weather = self.weather else {
            let alert = UIAlertController(title: "Error", message: "Something went wrong. Please, try again.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: { action in
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let dateFormatter = weather.relevantDateFormatter()
        
        self.cityLabel.text = weather.city
        self.weatherDescriptionLabel.text = weather.weatherDescription.capitalizingFirstLetter()
        self.temperatureLabel.text = String(weather.temperature) + "℃"
        self.sunriseLabel.text = "\(dateFormatter.string(from: weather.sunrise))"
        self.sunsetLabel.text = "\(dateFormatter.string(from: weather.sunset))"
        self.cloudinessLabel.text = String(weather.cloudiness) + " %"
        self.windLabel.text = String(weather.wind).replacingOccurrences(of: ".", with: ",") + " m/s"
        self.pressureLabel.text = String(weather.pressure) + " hPa"
        
        switch weather.weatherID {
        case 200..<300:
            self.backgroundImage.image = UIImage(named: "Thunderstorm")
        case 300..<400:
            self.backgroundImage.image = UIImage(named: "Drizzle")
        case 500..<600:
            self.backgroundImage.image = UIImage(named: "Rain")
        case 600..<700:
            self.backgroundImage.image = UIImage(named: "Snow")
        case 700..<800:
            self.backgroundImage.image = UIImage(named: "Fog")
        case 800:
            self.backgroundImage.image = UIImage(named: "Clear")
        case 800..<900:
            self.backgroundImage.image = UIImage(named: "Clouds")
        default:
            break
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1) {
            for subview in self.view.subviews {
                subview.alpha = 1.0
            }
        }
        
        guard let _ = self.weather else { return }
        UIView.animate(withDuration: 3) {
            self.backgroundImage.alpha = 1.0
            for image in self.weatherImages {
                image.alpha = 1.0
            }
        }
        
    }
    
    
}
