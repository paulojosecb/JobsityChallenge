//
//  FetchSeriesUseCase.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 17/09/22.
//

import Foundation
import UIKit

enum FetchSeriesError: Error {
    case invalidName
    case network
    case unknown
    
    static func valueBased(on repositoryError: RepositoryError) -> FetchSeriesError {
        switch repositoryError {
        case .network:
            return .network
        default:
            return .unknown
        }
    }
}

final class FetchSeriesUseCase: UseCase {
    
    let repository: FetchSeriesRepository
    
    enum RequestType {
        case page(Int)
        case byName(String)
        case byId(Int)
        case all
    }
    
    struct Request {
        let type: RequestType
    }
    
    struct Response {
        let series: [Serie]
    }
    
    init(repository: FetchSeriesRepository) {
        self.repository = repository
    }
    
    func dispatch(_ request: Request, _ completion: @escaping (Result<Response, Error>) -> ()) {
        self.repository.fetchSeries(with: request) { result in
            switch result {
            case .success(let series):
                completion(.success(.init(series: series)))
            case .failure(let error):
                completion(.failure(FetchSeriesError.valueBased(on: error)))
            }
        }
    }
    
    func validator(request: Request) throws {
        switch request.type {
        case .byName(let name):
            if name.isEmpty {
                throw FetchSeriesError.invalidName
            }
        default:
            return
        }
    }
}
