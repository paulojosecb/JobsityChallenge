//
//  SaveSerieAsFavoriteUseCase.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import Foundation

final class ToggleSerieAsFavoriteUseCase: UseCase {
    
    let repository: ToggleSerieAsFavoriteRepository
    
    struct Request {
        let seriesId: Int
    }
    
    struct Response {
        let isSaved: Bool
    }
    
    init(repository: ToggleSerieAsFavoriteRepository = DefaultToggleSerieAsFavoriteRepository()) {
        self.repository = repository
    }
    
    func dispatch(_ request: Request, _ completion: @escaping (Result<Response, Error>) -> ()) {
        self.repository.toggle(request) { result in
            switch result {
            case .success(let isSaved):
                completion(.success(.init(isSaved: isSaved)))
            case .failure(let error):
                completion(.failure(FetchEntityError.valueBased(on: error)))
            }
        }
    }
    
    func validator(request: Request) throws {
        
    }
    
}
