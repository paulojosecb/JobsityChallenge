//
//  File.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import Foundation

protocol ToggleSerieAsFavoriteRepository {
    func toggle(_ request: ToggleSerieAsFavoriteUseCase.Request, completion: @escaping (Result<Bool, RepositoryError>) -> ())
    func fetchServices(completion: @escaping (Result<[Serie], RepositoryError>) -> ())
}
