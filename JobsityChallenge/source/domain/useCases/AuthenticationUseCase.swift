//
//  AuthenticationUseCase.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import Foundation

enum AuthenticationUseCaseError: Error {
    case invalidPinInput
    case localAuthUnavailable
    case wrongPin
    case unknown
    
    static func valueBased(on repositoryError: AuthenticationRepositoryError) -> AuthenticationUseCaseError {
        switch repositoryError {
        case .unknown:
            return .unknown
        case .localAuthUnavailable:
            return .localAuthUnavailable
        case .wrongPin:
            return .wrongPin
        }
    }
}

final class AuthenticationUseCase: UseCase {
    
    private let repository: AuthenticationRepository
    
    enum AuthType {
        case localAuth
        case pin(String)
    }
    
    struct Request {
        let type: AuthType
    }
    
    struct Response {
        let authenticated: Bool
    }
    
    init(repository: AuthenticationRepository = DefaultAuthenticationRepository()) {
        self.repository = repository
    }
    
    func dispatch(_ request: Request, _ completion: @escaping (Result<Response, Error>) -> ()) {
        self.repository.auth(request: request) { result in
            switch result {
            case .success(let authenticated):
                completion(.success(.init(authenticated: authenticated)))
            case .failure(let error):
                completion(.failure(AuthenticationUseCaseError.valueBased(on: error)))
            }
        }
    }
    
    func validator(request: Request) throws {
        switch request.type {
        case .pin(let pin):
            if pin.count != 4 { throw AuthenticationUseCaseError.invalidPinInput }
        default:
            break
        }
    }
    
}
