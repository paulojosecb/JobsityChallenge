//
//  SeriesRepository.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 17/09/22.
//

import Foundation

class EntityRepository: FetchEntityRepository {
    
    let apiClient: APIClient
    let localStorage: LocalStorage
    
    init(apiClient: APIClient = DefaultApiClient(),
         localStorage: LocalStorage = DefaultLocalStorage()) {
        self.apiClient = apiClient
        self.localStorage = localStorage
    }
    
    func fetch<T>(with request: FetchEntityUseCase<T>.Request, completion: @escaping (Result<T, RepositoryError>) -> ()) where T : Codable {
        
        switch request.type {
        case .serie(let serieRequestType):
            switch serieRequestType {
            case .favorites:
                self.dispatchFavoriteSeriesRequest(with: request,
                                                   completion: completion)
                return
            default:
                break
            }
        default:
            break
        }

        guard let router = RouterFactory.makeRouter(for: request.type),
              let urlRequest = router.asURLRequest() else {
            completion(.failure(.unknown))
            return
        }

        self.apiClient.requestJSON(urlRequest: urlRequest) {  (result: Result<T, RequestError>) in
            switch result {
            case .success(let T):
                DispatchQueue.main.async {
                    completion(.success(T))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error.repositoryError))
                }
            }
        }
        
    }
    
    private func dispatchFavoriteSeriesRequest<T>(with request: FetchEntityUseCase<T>.Request, completion: @escaping (Result<T, RepositoryError>) -> ()) {
        
        self.localStorage.fetchFavorites { result in
            switch result {
            case .success(let favoriteSeries):
                guard favoriteSeries is T else {
                    DispatchQueue.main.async {
                        completion(.failure(.notFound))
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    completion(.success(favoriteSeries as! T))
                }
                
            case .failure(_):
                DispatchQueue.main.async {
                    completion(.failure(.notFound))
                }
            }
        }
        
    }
    
}
