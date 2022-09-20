//
//  SeriesRepository.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 17/09/22.
//

import Foundation

class SeriesRepository: FetchSeriesRepository {
    
    let apiClient: APIClient
    
    init(apiClient: APIClient = DefaultApiClient()) {
        self.apiClient = apiClient
    }
    
    func fetchSeries(with request: FetchSeriesUseCase.Request, completion: @escaping (Result<[Serie], RepositoryError>) -> ()) {
        
        guard let router = makeRouter(for: request.type),
              let urlRequest = try? router.asURLRequest() else {
            completion(.failure(.unknown))
            return
        }
        
        self.apiClient.requestJSON(urlRequest: urlRequest) {  (result: Result<[Serie], RequestError>) in
            switch result {
            case .success(let series):
                completion(.success(series))
            case .failure(let error):
                completion(.failure(error.repositoryError))
            }
        }
    }
    
    private func makeRouter(for requestType: FetchSeriesUseCase.RequestType) ->SeriesRouter? {
        var router: SeriesRouter?
        
        switch requestType {
        case .byName(let name):
            router = SeriesRouter.byName(name)
        case .byId(let id):
            router = SeriesRouter.byId(id)
        case .all:
            router = SeriesRouter.all
        case .paged(let page):
            router = SeriesRouter.paged(page)
        }
        
        return router
    }
}
