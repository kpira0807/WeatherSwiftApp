import Swinject
import UIKit

final class ListCitiesAssembly: Assembly {
    
    private let parent: NavigationNode
    
    init(_ parent: NavigationNode) {
        self.parent = parent
    }
    
    func assemble(container: Container) {
        container.register(ListCitiesControllerView.self) { (resolver, navigationHandler: ListCitiesNavigationHandler) in
            let model = ListCitiesModel(navigationHandler: navigationHandler)
            let viewModel = ListCitiesViewModel(model: model)
            let controller = ListCitiesControllerView(viewModel: viewModel)
            
            return controller!
        }.inObjectScope(.transient)
    }
    
}
