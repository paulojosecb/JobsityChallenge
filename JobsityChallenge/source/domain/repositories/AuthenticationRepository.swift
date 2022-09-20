//
//  AuthenticationRepository.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import Foundation

protocol AuthenticationRepository {
    func auth(request: AuthenticationUseCase.Request, completion: @escaping (Result<Bool, AuthenticationRepositoryError>) -> ())
}
