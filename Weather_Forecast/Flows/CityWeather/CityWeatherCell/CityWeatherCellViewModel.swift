import Foundation
import UIKit

final class CityWeatherCellViewModel {
    
    let date: String
    let temp: String
    let weatherImage: String
    
    init(
        date: String,
        temp: Double,
        weatherImage: String
    ) {
        self.date = date
        self.temp = "\(Int(round(temp))) °C"
        self.weatherImage = "https://openweathermap.org/img/wn/\(weatherImage)@2x.png"
    }
    
}

