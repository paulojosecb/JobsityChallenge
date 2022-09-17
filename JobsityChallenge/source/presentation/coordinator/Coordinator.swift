import UIKit

protocol Coordinator: AnyObject {
    func presentRootScreen(with scene: UIWindowScene)
    func start()
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
    
    func start() {
        self.rootViewController = ViewController()
        navigationController.viewControllers = [self.rootViewController!]
    }
    
    func presentRootScreen(with scene: UIWindowScene) {
        window.rootViewController = navigationController
        window.windowScene = scene
    }

}
