import Foundation

struct WeatherJSON: Codable {
    
    let list: [List]
    let city: City
    
}

struct List: Codable {
    
    let main: Main
    let weather: [Weather]
    let dt_txt: String
    
}

struct City: Codable {
    
    let id: Int
    let name: String
    let coord: CoordCity
    
}
