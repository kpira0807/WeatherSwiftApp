import Foundation
import UIKit
import Combine

final class CityWeatherViewModel {
    
    var requestState: AnyPublisher<RequestState, Never> {
        model.requestState.eraseToAnyPublisher()
    }
    
    var reloadCitiesData: AnyPublisher<Void, Never> {
        _reloadCitiesData.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    var cellViewModels: [CityWeatherCellViewModel] = []
    var cityNameViewModel: CityNameViewModel?
    var cityCurrentWeatherViewModel: CityCurrentWeatherViewModel?
    
    private let model: CityWeatherModel
    private let _reloadCitiesData = PassthroughSubject<Void, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    init(model: CityWeatherModel) {
        self.model = model
        
        setupBindings()
        buildCurrentInfo()
    }
    
    private func setupBindings() {
        model.reloadCitiesData.sink { [weak self] _ in
            guard let self = self else { return }
            
            self.buildCellViewModels()
            self.buildCurrentInfo()
            self._reloadCitiesData.send(())
        }.store(in: &subscriptions)
    }
    
    private func buildCellViewModels() {
        cellViewModels = model.weatherLong.map { value in
            CityWeatherCellViewModel(
                date: value?.dt_txt ?? "",
                temp: value?.main.temp ?? 0.0,
                weatherImage: value?.weather.map{$0.icon}.first ?? "10d"
            )
        }
    }
    
    private func buildCurrentInfo() {
        if let cityModel = model.cityModel {
            cityNameViewModel = CityNameViewModel(city: cityModel.name, country: cityModel.country)
        } else {
            cityNameViewModel = CityNameViewModel(
                city: model.weatherModel?.name ?? "City",
                country: model.weatherModel?.sys.country ?? "Country"
            )
        }
        
        
        let name = model.weatherModel?.weather.map{$0.main}.first
        let image = model.weatherModel?.weather.map{$0.icon}.first
        cityCurrentWeatherViewModel = CityCurrentWeatherViewModel(
            currentWeatherImage: image ?? "10d",
            currentTemp: model.weatherModel?.main.temp ?? 0.0,
            currentWeatherName: name ?? "XXX"
        )
    }
    
}

