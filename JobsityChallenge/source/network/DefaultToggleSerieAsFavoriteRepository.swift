//
//  ToggleSerieAsFavoriteRepository.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import Foundation

final class DefaultToggleSerieAsFavoriteRepository: ToggleSerieAsFavoriteRepository {
    func toggle(_ request: ToggleSerieAsFavoriteUseCase.Request, completion: @escaping (Result<Bool, RepositoryError>) -> ()) {
        completion(.success(true))
    }    
}
