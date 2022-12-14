//
//  EpisodeRouter.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import Foundation

internal enum EpisodeRouter: Router {
    case byId(Int)
    case fromSeason(Int)
    case fromSerie(Int)

    internal static let baseUrl = EnvConfiguration.apiBaseURL

    fileprivate var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }

    fileprivate var path: String {
        switch self {
        case .byId(let id):
            return "episodes/\(id)"
        case .fromSeason(let id):
            return "seasons/\(id)/episodes"
        case .fromSerie(let id):
            return "shows/\(id)/episodes"
        }
    }
    
    fileprivate var queryItems: [URLQueryItem] {
        switch self {
        default:
            return []
        }
    }
    
    internal func asURLRequest() -> URLRequest? {
        guard let url = URL(string: EpisodeRouter.baseUrl)?.appending(queryItems) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }

}
