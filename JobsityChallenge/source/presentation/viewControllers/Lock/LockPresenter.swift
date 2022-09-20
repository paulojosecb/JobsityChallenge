//
//  LockPresenter.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import Foundation

protocol LockPresenter {
    func presentLocalAuthIfAvailable(completion: @escaping (Result<Bool, Error>) -> ())
    func validate(pin: String, completion: @escaping (Result<Bool, Error>) -> ())
}

final class DefaultLockPresenter: LockPresenter {
    
    let useCase: AuthenticationUseCase
    let localAuth: LocalAuth
    
    init(useCase: AuthenticationUseCase = AuthenticationUseCase(),
         localAuth: LocalAuth = DefaultLocalAuth()) {
        self.useCase = useCase
        self.localAuth = localAuth
    }
    
    func presentLocalAuthIfAvailable(completion: @escaping (Result<Bool, Error>) -> ()) {
        
        self.localAuth.isAvailable { result in
            switch result {
            case .success(let available):
                if available {
                    self.useCase.exec(request: .init(type: .localAuth)) { result in
                        switch result {
                        case .success(let response):
                            completion(.success(response.authenticated))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            default:
                break
            }
        }
        
    }
    
    func validate(pin: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        
        self.useCase.exec(request: .init(type: .pin(pin))) { result in
            switch result {
            case .success(let response):
                completion(.success(response.authenticated))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
}
