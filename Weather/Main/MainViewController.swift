//
//  MainViewController.swift
//  Weather
//
//  Created by Lyudmila Platonova on 7.10.21.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var showWeatherButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var currentCity = ""
    
    var currentWeather: Weather?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboard()
        cityTextField.delegate = self
        cityTextField.layer.cornerRadius = 8
        showWeatherButton.layer.cornerRadius = 8
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.alpha = 0
        if currentCity != "" {
            showWeatherButton.isEnabled = true
        }
        
    }
    
    @IBAction func getLocation(_ sender: UIButton) {
        self.currentCity = appDelegate.cityName
        self.cityTextField.text = currentCity
        showWeatherButton.isEnabled = true
    }
    
    @IBAction func cityInputBegined(_ sender: UITextField) {
        showWeatherButton.isEnabled = false
        currentCity = ""
    }
    
    @IBAction func cityInputChanged(_ sender: UITextField) {
        guard let city = sender.text else {
            showWeatherButton.isEnabled = false
            currentCity = ""
            return
        }
        if city.count >= 2 {
            showWeatherButton.isEnabled = true
        } else {
            showWeatherButton.isEnabled = false
        }
    }
    
    @IBAction func showWeather(_ sender: UIButton) {
        showWeatherButton.isEnabled = false
        currentCity = cityTextField.text ?? ""
        DispatchQueue.main.async {
            NetworkingManager.shared.getWeather(city: self.cityTextField.text ?? "")
        }
        activityIndicator.alpha = 1
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            if NetworkingManager.shared.error != 0 {
                print ("Error")
                var errorTitle = ""
                var errorMessage = ""
                switch NetworkingManager.shared.error {
                case 400..<500:
                    errorTitle = "The city was not found"
                    errorMessage = "Please, check your input."
                case 500:
                    errorTitle = "Internal Server Error"
                    errorMessage = "Please, try later."
                default:
                    errorTitle = "Error"
                    errorMessage = "Something went wrong. Please, try again."
                }
                let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(ok)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.alpha = 0
                self.present(alert, animated: true, completion: nil)
            } else {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.alpha = 0
                let storyboard = UIStoryboard(name: "WeatherViewController", bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController {
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
}

extension MainViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        for textField in self.view.subviews where textField is UITextField {
            textField.resignFirstResponder()
        }
        self.view.endEditing(true)
        return true
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
