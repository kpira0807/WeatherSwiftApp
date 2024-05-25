import Swinject
import UIKit

final class CityWeatherAssembly: Assembly {
    
    private let parent: NavigationNode
    
    init(_ parent: NavigationNode) {
        self.parent = parent
    }
    
    func assemble(container: Container) {
        container.register(CityWeatherViewController.self) { (
            resolver,
            cityModel: CityModel?,
            lon: Double?,
            lat: Double?,
            navigationHandler: CityWeatherNavigationHandler
        ) in
            let model = CityWeatherModel(
                cityModel: cityModel,
                lon: lon,
                lat: lat,
                navigationHandler: navigationHandler
            )
            let viewModel = CityWeatherViewModel(model: model)
            let controller = CityWeatherViewController(viewModel: viewModel)
            
            return controller!
        }.inObjectScope(.transient)
    }
    
}
