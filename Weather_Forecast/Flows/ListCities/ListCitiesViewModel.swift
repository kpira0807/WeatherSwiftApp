import Foundation
import CoreLocation
import UIKit
import Combine

final class ListCitiesViewModel {
    
    var requestState: AnyPublisher<RequestState, Never> {
        model.requestState.eraseToAnyPublisher()
    }
    
    var reloadCitiesData: AnyPublisher<Void, Never> {
        _reloadCitiesData.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    var cellViewModels: [ListCitiesCellViewModel] = []
    
    private let model: ListCitiesModel
    private let _reloadCitiesData = PassthroughSubject<Void, Never>()
    private var subscriptions = Set<AnyCancellable>()
    
    init(model: ListCitiesModel) {
        self.model = model
        
        setupBindings()
    }
    
    func currentWeather(lon: Double, lat: Double) {
        model.showWeatherCityInfo(cityModel: nil, lon: lon, lat: lat)
    }
    
    private func setupBindings() {
        model.reloadCitiesData.sink { [weak self] _ in
            guard let self = self else { return }
            
            self.buildCellViewModels()
            self._reloadCitiesData.send(())
        }.store(in: &subscriptions)
    }
    
    private func buildCellViewModels() {
        cellViewModels = model.cityModel.map { value in
            let currentLocale : NSLocale = NSLocale.init(localeIdentifier :  NSLocale.current.identifier)
            let countryName : String? = currentLocale.displayName(forKey: NSLocale.Key.countryCode, value: value.country)
            
            return ListCitiesCellViewModel(city: value.name, country: countryName ?? "", onSelect: { [weak self] in
                self?.model.showWeatherCityInfo(cityModel: value, lon: nil, lat: nil)
            })
        }
    }
    
}
