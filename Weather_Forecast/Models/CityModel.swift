import Foundation

struct CityModel: Codable {
    
    let id: Int
    let name: String
    let country: String
    let coord: Coord
    
}

struct Coord: Codable, Equatable {
    
    let lon: Double
    let lat: Double
    
}
