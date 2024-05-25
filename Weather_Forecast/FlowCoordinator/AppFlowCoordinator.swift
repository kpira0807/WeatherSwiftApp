import UIKit

final class AppNavigator: NavigationNode {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        
        super.init(parent: nil)
    }
    
    func startFlow() {
        let coordinator = ListCitiesCoordinator(parent: self)
        let controller = coordinator.createFlow()
        
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }
    
}
