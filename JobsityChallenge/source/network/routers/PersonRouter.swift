//
//  PersonRouter.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import Foundation

internal enum PersonRouter: Router {
    case byId(Int)
    case byName(String)
    case credits(Int)

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
            return "people/\(id)"
        case .credits(let id):
            return "people/\(id)/castcredits"
        default:
            return "people"
        }
    }
    
    fileprivate var queryItems: [URLQueryItem] {
        switch self {
        case .byName(let name):
            return [URLQueryItem(name: "q", value: name)]
        case .credits(_):
            return [URLQueryItem(name: "embed", value: "show")]
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
