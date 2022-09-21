//
//  SettingsViewController.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 21/09/22.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    let settingsView: SettingsView
    let presenter: SettingsPresenter
    
    init(settingsView: SettingsView = SettingsView(), presenter: SettingsPresenter = DefaultSettingsPresenter()) {
        self.settingsView = settingsView
        self.presenter = presenter
        
        self.settingsView.isTouchIDEnabledSwitch.isOn = self.presenter.isTouchIDEnabled()
        self.settingsView.isPinEnabledSwitch.isOn = self.presenter.isPinEnabled()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = settingsView
        settingsView.delegate = self
    }
    
    // MARK: UIAlertControllers
    lazy var createInputAlertController: UIAlertController = {
        let validator: (String) -> Bool = { $0.count == 4 }
        
        let alertController = UIAlertController.createInputAlertController(title: "Please type your new pin",
                                                                           message: nil,
                                                                           okButtonTitle: "Create",
                                                                           validator: validator) { text in
            self.set(newPin: text)
        } errorCompletion: {
            self.present(self.inputErrorAlertController, animated: true, completion: nil)
        }

        return alertController
    }()
    
    lazy var inputErrorAlertController: UIAlertController = {
        let errorAlertController = UIAlertController.createErrorAlertController(KeychainError.noPassword, message: "Type a pin with 4 numbers") {
            self.present(self.createInputAlertController, animated: true, completion: nil)
        }
        
        return errorAlertController
    }()
    
    private func set(newPin: String) {
        self.presenter.setNewPin(pin: newPin) { result in
            switch result {
            case .success(let setted):
                let _ = self.presenter.togglePin(newValue: setted)
            case .failure(let error):
                let errorAlertController = UIAlertController.createErrorAlertController(error, message: "An Error occurred while validating your pin. Try again") {
                    self.cleanState()
                }
                
                self.present(errorAlertController, animated: true, completion: nil)
            }
        }
    }
    
    private func cleanState() {
        self.settingsView.isPinEnabledSwitch.isOn = false
        self.settingsView.isTouchIDEnabledSwitch.isOn = false
        self.settingsView.isTouchIDEnabledSwitch.isEnabled = false
        
        let _ = self.presenter.toggleTouchID(newValue: false)
        let _ = self.presenter.togglePin(newValue: false)
        
        self.presenter.delete { result in
            
        }
    }
}

extension SettingsViewController: SettingsViewDelegate {
    func didIsTouchIDEnabledChange(newValue: Bool) {
        let _ = self.presenter.toggleTouchID(newValue: newValue)
    }
    
    func didIsPinEnabledChange(newValue: Bool) {
        if newValue {
            self.present(createInputAlertController, animated: true, completion: nil)
        } else {
            self.cleanState()
            self.presenter.delete { result in
                
            }
        }
    }
}
