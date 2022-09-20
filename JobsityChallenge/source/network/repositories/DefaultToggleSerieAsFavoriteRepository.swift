//
//  ToggleSerieAsFavoriteRepository.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import Foundation

final class DefaultToggleSerieAsFavoriteRepository: ToggleSerieAsFavoriteRepository {

    let localStorage: LocalStorage
    
    init(localStorage: LocalStorage = DefaultLocalStorage()) {
        self.localStorage = localStorage
        
        
    }
    
    func toggle(_ request: ToggleSerieAsFavoriteUseCase.Request, completion: @escaping (Result<Bool, RepositoryError>) -> ()) {
        
        guard let isSaved = try? self.localStorage.toggleOnFavorite(serie: request.serie) else {
            completion(.failure(.unknown))
            return
        }
        
        completion(.success(isSaved))
    }
    
    func fetchServices(completion: @escaping (Result<[Serie], RepositoryError>) -> ()) {
        self.localStorage.fetchFavorites { result in
            switch result {
            case .success(let series):
                completion(.success(series))
            case .failure(_):
                completion(.failure(.unknown))
            }
        }
    }
}
