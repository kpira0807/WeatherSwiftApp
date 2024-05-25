import Foundation
import UIKit
import Combine
import CoreLocation

protocol CityWeatherNavigationHandler {}

final class CityWeatherModel {
    
    private let navigationHandler: CityWeatherNavigationHandler
    
    let requestState = CurrentValueSubject<RequestState, Never>(.finished)
    let reloadCitiesData = PassthroughSubject<Void, Never>()
    
    let cityModel: CityModel?
    let lon: Double?
    let lat: Double?
    var weatherModel: WeatherModel?
    var weatherLong = [List?]()
    
    init(
        cityModel: CityModel?,
        lon: Double?,
        lat: Double?,
        navigationHandler: CityWeatherNavigationHandler
    ) {
        self.cityModel = cityModel
        self.lon = lon
        self.lat = lat
        self.navigationHandler = navigationHandler
        
        fetchCurrentData()
        fetchWeatherLongData()
    }
    
    private func fetchCurrentData() {
        
        var longitude = Double()
        var latitude = Double()
        
        if cityModel != nil {
            longitude = (cityModel?.coord.lon)!
            latitude = (cityModel?.coord.lat)!
        } else if lon != nil && lat != nil {
            longitude = lon!
            latitude = lat!
        }
        
        let apiKey = "a2ec7236d3086c7050c4bedc27b89ac5"
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        let urls = URL(string: url)
        
        URLSession.shared.dataTask(with: urls!) { (data, response, error) in
            guard let data = data else { return }
            
            Task {
                do {
                    let decoder = JSONDecoder()
                    let weatherModelInfo = try decoder.decode(WeatherModel.self, from: data)
                    DispatchQueue.main.async { [self] in
                        self.weatherModel = weatherModelInfo
                        
                        reloadCitiesData.send(())
                        requestState.send(.finished)
                    }
                } catch {
                    self.requestState.send(.failed(error))
                    print("Error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    private func fetchWeatherLongData() {
        
        var longitude = Double()
        var latitude = Double()
        
        if cityModel != nil {
            longitude = (cityModel?.coord.lon)!
            latitude = (cityModel?.coord.lat)!
        } else if lon != nil && lat != nil {
            longitude = lon!
            latitude = lat!
        }
        
        let apiKey = "a2ec7236d3086c7050c4bedc27b89ac5"
        let url = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        let urls = URL(string: url)
        
        URLSession.shared.dataTask(with: urls!) { (data, response, error) in
            guard let data = data else { return }
            
            Task {
                do {
                    let decoder = JSONDecoder()
                    let weatherLongInfo = try decoder.decode(WeatherJSON.self, from: data)
                    DispatchQueue.main.async { [self] in
                        self.weatherLong = weatherLongInfo.list
                        reloadCitiesData.send(())
                        requestState.send(.finished)
                    }
                } catch {
                    self.requestState.send(.failed(error))
                    print("Error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
}
