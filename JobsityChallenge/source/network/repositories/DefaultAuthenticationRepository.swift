//
//  AuthenticationRepository.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import Foundation

final class DefaultAuthenticationRepository: AuthenticationRepository {
    
    let localAuth: LocalAuth
    let keychainStorage: KeychainStorage
    
    init(localAuth: LocalAuth = DefaultLocalAuth(), keychainStorage: KeychainStorage = DefaultKeychainStorage()) {
        self.localAuth = localAuth
        self.keychainStorage = keychainStorage
    }
    
    func auth(request: AuthenticationUseCase.Request, completion: @escaping (Result<Bool, AuthenticationRepositoryError>) -> ()) {
        
        switch request.type {
        case .localAuth:
            self.localAuth.authenticate { result in
                switch result {
                case .success(let authenticated):
                    completion(.success(authenticated))
                case .failure(_):
                    completion(.failure(.localAuthUnavailable))
                }
            }
        case .pin(let pin):
            self.keychainStorage.validate(pin: pin) { result in
                switch result {
                case .success(let authenticated):
                    completion(.success(authenticated))
                case .failure(_):
                    completion(.failure(.wrongPin))
                }
            }
        }
        
    }
    
}
