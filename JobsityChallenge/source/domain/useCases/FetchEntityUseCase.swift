//
//  FetchSeriesUseCase.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 17/09/22.
//

import Foundation
import UIKit

enum FetchEntityError: Error {
    case invalidName
    case network
    case unknown
    
    static func valueBased(on repositoryError: RepositoryError) -> FetchEntityError {
        switch repositoryError {
        case .network:
            return .network
        default:
            return .unknown
        }
    }
}

final class FetchEntityUseCase<T: Codable>: UseCase {
    
    private let repository: FetchEntityRepository
    
    enum RequestType {
        case serie(SerieRequestType)
        case episode(EpisodeRequestType)
        case person(PersonRequestType)
        case season(SeasonRequestType)
    }
    
    enum SerieRequestType {
        case paged(Int)
        case byName(String)
        case byId(Int)
        case all
        case favorites
    }
    
    enum EpisodeRequestType {
        case byId(Int)
        case fromSeason(Int)
        case fromSerie(Int)
    }
    
    enum PersonRequestType {
        case byName(String)
        case byId(Int)
        case credits(Int)
    }
    
    enum SeasonRequestType {
        case byId(Int)
        case bySerie(Int)
    }
    
    struct Request {
        let type: RequestType
    }
        
    struct Response {
        let entities: T
    }
    
    init(repository: FetchEntityRepository = EntityRepository()) {
        self.repository = repository
    }
    
    func dispatch(_ request: Request, _ completion: @escaping (Result<Response, Error>) -> ()) {
        self.repository.fetch(with: request) { result in
            switch result {
            case .success(let entities):
                completion(.success(.init(entities: entities)))
            case .failure(let error):
                completion(.failure(FetchEntityError.valueBased(on: error)))
            }
        }
    }
    
    func validator(request: Request) throws {
        switch request.type {
        case .serie(let serieRequest):
            switch serieRequest {
            case .byName(let name):
                if name.isEmpty {
                    throw FetchEntityError.invalidName
                }
            default:
                return
            }
        case .person(let personRequest):
            switch personRequest {
            case .byName(let name):
                if name.isEmpty {
                    throw FetchEntityError.invalidName
                }
            default:
                return
            }
        default:
            return
        }
    }
}
