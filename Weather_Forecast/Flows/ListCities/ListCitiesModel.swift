import Foundation
import Combine

protocol ListCitiesNavigationHandler {
    
    func listModelDidRequestToPresentCityWeatherInfo(
        _ model: ListCitiesModel,
        cityModel: CityModel?,
        lon: Double?,
        lat: Double?
    )
    
}

final class ListCitiesModel {
    
    private let navigationHandler: ListCitiesNavigationHandler
    
    let requestState = CurrentValueSubject<RequestState, Never>(.finished)
    let reloadCitiesData = PassthroughSubject<Void, Never>()
    var cityModel = [CityModel]()
    
    init(navigationHandler: ListCitiesNavigationHandler) {
        self.navigationHandler = navigationHandler
        
        loadCities()
    }
    
    func showWeatherCityInfo(cityModel: CityModel?, lon: Double?, lat: Double?) {
        navigationHandler.listModelDidRequestToPresentCityWeatherInfo(self, cityModel: cityModel, lon: lon, lat: lat)
    }
    
    func loadCities() {
        DispatchQueue.global().async  {
            if let path = Bundle.main.path(forResource: "city.list", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let jsonDecoder = JSONDecoder()
                    var cities = try jsonDecoder.decode([CityModel].self, from: data)
                    
                    cities.sort {
                        $0.name < $1.name
                    }
                    
                    DispatchQueue.main.async { [self] in
                        
                        self.cityModel.append(contentsOf: cities)
                        reloadCitiesData.send(())
                        requestState.send(.finished)
                    }
                }
                catch {
                    self.requestState.send(.failed(error))
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
}
