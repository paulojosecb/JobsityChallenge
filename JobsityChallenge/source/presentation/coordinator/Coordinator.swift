import UIKit

protocol Coordinator: AnyObject {
    func presentRootScreen(with scene: UIWindowScene)
    func start(isPinEnabled: Bool)
    
    func presentHomeScreenFromLock()
}

class MainCoordinator: Coordinator {

    static let shared = MainCoordinator()
    var rootViewController: UIViewController?
    
    let navigationController: UINavigationController
    
    lazy var window: UIWindow = {
        let window = UIWindow(frame: .zero)
        window.makeKeyAndVisible()
        return window
    }()

    init() {
        self.navigationController = UINavigationController()
    }
    
    func start(isPinEnabled: Bool) {
        self.rootViewController = isPinEnabled ? LockViewController(coordinator: self) : SeriesViewController()
        navigationController.viewControllers = [self.rootViewController!]
    }
    
    func presentRootScreen(with scene: UIWindowScene) {
        window.rootViewController = navigationController
        window.windowScene = scene
    }
    
    func presentHomeScreenFromLock() {
        let navController = UINavigationController()
        let viewController = SeriesViewController()
        
        navController.viewControllers = [viewController]
        navController.modalPresentationStyle = .overCurrentContext
        navController.navigationBar.prefersLargeTitles = true
        
        navigationController.present(navController, animated: true)
    }

}
