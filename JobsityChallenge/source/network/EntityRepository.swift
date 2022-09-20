//
//  SeriesRepository.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 17/09/22.
//

import Foundation

class EntityRepository: FetchEntityRepository {
    
    let apiClient: APIClient
    
    init(apiClient: APIClient = DefaultApiClient()) {
        self.apiClient = apiClient
    }
    
    func fetch<T>(with request: FetchEntityUseCase<T>.Request, completion: @escaping (Result<T, RepositoryError>) -> ()) where T : Codable {
        
        guard let router = RouterFactory.makeRouter(for: request.type),
              let urlRequest = router.asURLRequest() else {
            completion(.failure(.unknown))
            return
        }

        self.apiClient.requestJSON(urlRequest: urlRequest) {  (result: Result<T, RequestError>) in
            switch result {
            case .success(let T):
                completion(.success(T))
            case .failure(let error):
                completion(.failure(error.repositoryError))
            }
        }
        
    }
    
}
