//
//  LockViewController.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import UIKit

final class LockViewController: UIViewController {
    
    enum LockViewError: Error {
        case invalidInput
        case invalidPin
    }
    
    let lockView: LockView
    let presenter: LockPresenter
    let coordinator: Coordinator
        
    init(coordinator: Coordinator, presenter: LockPresenter = DefaultLockPresenter()) {
        self.coordinator = coordinator
        self.presenter = presenter
        self.lockView = LockView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIAlertControllers
    lazy var createInputAlertController: UIAlertController = {
        let validator: (String) -> Bool = { $0.count == 4 }
        
        let alertController = UIAlertController.createInputAlertController(title: "Please type your pin",
                                                                           message: nil,
                                                                           okButtonTitle: "Validate",
                                                                           validator: validator) { text in
            self.validate(pin: text)
        } errorCompletion: {
            self.present(self.inputErrorAlertController, animated: true, completion: nil)
        }

        return alertController
    }()
    
    lazy var inputErrorAlertController: UIAlertController = {
        let errorAlertController = UIAlertController.createErrorAlertController(LockViewError.invalidInput, message: "Type a pin with 4 numbers") {
            self.present(self.createInputAlertController, animated: true, completion: nil)
        }
        
        return errorAlertController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = lockView
        lockView.delegate = self
        lockView.setupViews()
        
        self.presenter.presentLocalAuthIfAvailable { result in
            switch result {
            case .success(let authenticated):
                if authenticated {
                    self.coordinator.presentHomeScreenFromLock()
                } else {
                    self.present(self.createInputAlertController, animated: true, completion: nil)
                }
            case .failure(_):
                self.present(self.createInputAlertController, animated: true, completion: nil)
            }
        }
    }
    
    private func validate(pin: String) {
        self.presenter.validate(pin: pin) { result in
            switch result {
            case .success(let authenticated):
                if authenticated {
                    self.coordinator.presentHomeScreenFromLock()
                } else {
                    self.presenterPinErrorAlert()
                }
            case .failure(_):
                self.presenterGeneralErrorAlert()
            }
        }
    }
    
    private func presenterPinErrorAlert() {
        let errorAlertController = UIAlertController.createErrorAlertController(LockViewError.invalidPin, message: "Invalid pin") {
            self.present(self.createInputAlertController, animated: true, completion: nil)
        }
        self.present(errorAlertController, animated: true, completion: nil)
    }
    
    private func presenterGeneralErrorAlert() {
        let errorAlertController = UIAlertController.createErrorAlertController(LockViewError.invalidPin, message: "An Error occurred while validating your pin. Try again") {
            self.present(self.createInputAlertController, animated: true, completion: nil)
        }
        self.present(errorAlertController, animated: true, completion: nil)
    }
    
}

extension LockViewController: LockViewDelegate {
    func didPressShowPinButton() {
        self.present(createInputAlertController, animated: true, completion: nil)
    }
}
