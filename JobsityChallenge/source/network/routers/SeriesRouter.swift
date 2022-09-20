//
//  SeriesRouter.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 17/09/22.
//

import Foundation

internal enum SeriesRouter {
    
    case paged(Int)
    case all
    case byName(String)
    case byId(Int)

    internal static let baseUrl = "https://api.tvmaze.com/"

    fileprivate var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }

    fileprivate var path: String {
        switch self {
        case .byId(let id):
            return "shows/\(id)"
        default:
            return "shows"
        }
    }
    
    fileprivate var queryItems: [URLQueryItem] {
        switch self {
        case .paged(let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        case .byName(let name):
            return [URLQueryItem(name: "q", value: name)]
        default:
            return []
        }
    }
    
    internal func asURLRequest() throws -> URLRequest? {
        guard let url = URL(string: SeriesRouter.baseUrl)?.appending(queryItems) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }

}
