import Foundation

struct WeatherModel: Codable {
    
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let id: Int
    let name: String
    let base: String
    let coord: CoordCity
    let sys: SYS
    
}

struct Weather: Codable {
    
    let main: String
    let description: String?
    let icon: String
    
}

struct Main: Codable {
    
    let temp: Double?
    let humidity: Int?
    let temp_max: Double
    let temp_min: Double
    let pressure: Int
    
}

struct Wind: Codable {
    
    let speed: Double
    
}

struct CoordCity: Codable {
    
    let lat: Double
    let lon: Double
    
}

struct SYS: Codable {
    
    let country: String
    let id: Int
    
}
