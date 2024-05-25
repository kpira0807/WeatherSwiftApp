import Foundation
import UIKit

final class CityCurrentWeatherViewModel {
    
    let currentWeatherImage: String
    let currentTemp: String
    let currentWeatherName: String
    
    init(
        currentWeatherImage: String,
        currentTemp: Double,
        currentWeatherName: String
    ) {
        self.currentWeatherImage = "https://openweathermap.org/img/wn/\(currentWeatherImage)@2x.png"
        self.currentTemp = "\(Int(round(currentTemp))) °C"
        self.currentWeatherName = currentWeatherName
    }
    
}

