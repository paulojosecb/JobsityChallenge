//
//  UseCase.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 17/09/22.
//

import Foundation

protocol UseCase {
    associatedtype T
    associatedtype U
    func exec(request: T, completion: @escaping (Result<U, Error>) -> ())
    func dispatch(_ request: T, _ completion: @escaping (Result<U, Error>) -> ())
    func validator(request: T) throws
}

extension UseCase {
    func exec(request: T, completion: @escaping (Result<U, Error>) -> ()) {
        do {
            try self.validator(request: request)
            self.dispatch(request, completion)
        } catch let error {
            completion(.failure(error))
        }
    }
}
