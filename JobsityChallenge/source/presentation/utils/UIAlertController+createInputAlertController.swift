//
//  UIAlertController.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import UIKit

extension UIAlertController {
    static func createInputAlertController(title: String,
                                             message: String? = nil,
                                             okButtonTitle: String? = "OK",
                                             validator: @escaping (String) -> Bool,
                                             completion: ((String) -> ())? = nil,
                                             errorCompletion: (() -> ())? = nil) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addTextField()
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { action in }
        
        let okAction = UIAlertAction(title: okButtonTitle, style: .default) { [unowned alertController] _ in
            guard let textfield = alertController.textFields?[0],
            let text = textfield.text else { return }
            
            if validator(text) {
                completion?(text)
            } else {
                errorCompletion?()
            }
        }
                        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        return alertController
    }
    
    static func createErrorAlertController(_ error: Error,
                                           message: String? = nil,
                                           completion: (()->())? = nil) -> UIAlertController
    {
        let alertController = UIAlertController(title: "Sorry, an error has occurred", message: message ?? error.localizedDescription, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            completion?()
        }))
        
        return alertController
    }
}
