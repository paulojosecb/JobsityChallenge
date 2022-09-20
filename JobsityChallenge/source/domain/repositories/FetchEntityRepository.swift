//
//  FetchUseCaseRepository.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 17/09/22.
//

import Foundation

protocol FetchEntityRepository {
    func fetch<T: Codable>(with request: FetchEntityUseCase<T>.Request, completion: @escaping (Result<T, RepositoryError>) -> ())
}
