//
//  LocalAuth.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import Foundation
import LocalAuthentication

protocol LocalAuth {
    func isAvailable(completion: @escaping (Result<Bool, Error>) -> ())
    func authenticate(completion: @escaping (Result<Bool, Error>) -> ()) 
}

enum LocalAuthError: Error {
    case localAuthUnavailable
    case touchIDUnavailable
    case errorWhileAuthenticatingWithTouchID
}

final class DefaultLocalAuth: LocalAuth {
    
    let context = LAContext()
    
    func isAvailable(completion: @escaping (Result<Bool, Error>) -> ()) {
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            completion(.failure(LocalAuthError.localAuthUnavailable))
            return
        }
        
        completion(.success(true))
    }
    
    func authenticate(completion: @escaping (Result<Bool, Error>) -> ()) {
            
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            completion(.failure(LocalAuthError.localAuthUnavailable))
            return
        }
                
        if (context.biometryType == LABiometryType.touchID) {
            context.evaluatePolicy(
                LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Authentication is required for access",
                reply: {(success, error) in
                    DispatchQueue.main.async {
                        if let _ = error {
                            completion(.failure(LocalAuthError.errorWhileAuthenticatingWithTouchID))
                        } else {
                            DispatchQueue.main.async {
                                completion(.success(success))
                            }
                        }
                    }
              })
        } else {
            completion(.failure(LocalAuthError.touchIDUnavailable))
        }
    }
    
    
}
