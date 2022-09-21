//
//  SeasonRouter.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import Foundation

internal enum SeasonRouter: Router {
    case byId(Int)
    case bySerie(Int)

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
            return "seasons/\(id)"
        case .bySerie(let id):
            return "shows/\(id)/seasons"
        }
    }
    
    fileprivate var queryItems: [URLQueryItem] {
        switch self {
        default:
            return []
        }
    }
    
    internal func asURLRequest() -> URLRequest? {
        guard let url = URL(string: PersonRouter.baseUrl)?.appending(queryItems) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }

}
