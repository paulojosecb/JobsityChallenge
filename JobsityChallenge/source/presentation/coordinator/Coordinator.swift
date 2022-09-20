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
        self.rootViewController = isPinEnabled ? LockViewController(coordinator: self) : ViewController()
        navigationController.viewControllers = [self.rootViewController!]
    }
    
    func presentRootScreen(with scene: UIWindowScene) {
        window.rootViewController = navigationController
        window.windowScene = scene
    }
    
    func presentHomeScreenFromLock() {
        let viewController = ViewController()
        viewController.modalPresentationStyle = .fullScreen
        navigationController.present(viewController, animated: true, completion: nil)
    }

}
