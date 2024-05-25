import UIKit
import Swinject

final class ListCitiesCoordinator: NavigationNode {
    
    var navigationController: UINavigationController? {
        rootViewController.navigationController
    }
    
    private weak var rootViewController: UIViewController!
    private weak var viewController: UIViewController?
    private var container: Container!
    
    override init(parent: NavigationNode?) {
        super.init(parent: parent)
        
        registerFlow()
        addHandlers()
    }
    
    private func registerFlow() {
        container = Container()
        
        ListCitiesAssembly(self).assemble(container: container)
        CityWeatherAssembly(self).assemble(container: container)
    }
    
    private func addHandlers() {
        // add Settings flow event handlers
    }
    
}

extension ListCitiesCoordinator: Coordinator {
    
    func createFlow() -> UIViewController {
        let controller: ListCitiesControllerView = container.autoresolve(argument: self as ListCitiesNavigationHandler)
        rootViewController = controller
        let navigation = UINavigationController(rootViewController: controller)
        
        return navigation
    }
    
}

extension ListCitiesCoordinator: ListCitiesNavigationHandler {
    
    func listModelDidRequestToPresentCityWeatherInfo(_ model: ListCitiesModel, cityModel: CityModel?, lon: Double?, lat: Double?) {
        let controller: CityWeatherViewController = container.autoresolve(arguments: cityModel, lon, lat, self as CityWeatherNavigationHandler)
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension ListCitiesCoordinator: CityWeatherNavigationHandler {}
