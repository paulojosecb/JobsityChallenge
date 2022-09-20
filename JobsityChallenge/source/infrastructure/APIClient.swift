//
//  APIClient.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 17/09/22.
//

import Foundation

protocol APIClient {
    func requestJSON<T: Decodable>(urlRequest: URLRequest, completion: @escaping (Result<T, RequestError>) -> Void)
}

public struct ErrorResult: Codable {
    public var statusCode: Int?
}

enum RequestError: Error {
    case noData
    case apiError(Int)
    case parse

    var code: Int {
        switch self {
        case .noData, .parse:
            return -1
        case let .apiError(code):
            return code
        }
    }
    
    var repositoryError: RepositoryError {
        switch self {
        case .noData:
            return .notFound
        case .parse:
            return .unknown
        case .apiError(_):
            return .unknown
        }
    }
    
}


final class DefaultApiClient: APIClient {
    
    static let shared = DefaultApiClient()
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?

    func requestJSON<T>(urlRequest: URLRequest, completion: @escaping (Result<T, RequestError>) -> Void) where T : Decodable {
        
        request(urlRequest: urlRequest) { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let jsonObject = try decoder.decode(T.self, from: data)
                    completion(Result.success(jsonObject))
                } catch _ {
                    completion(.failure(.parse))
                }
            case .failure(_):
                completion(.failure(RequestError.apiError(-1)))
            }
        }
    }
    
    private func request(urlRequest: URLRequest, completion: @escaping (Result<Data?, Error>) -> Void) {
        dataTask?.cancel()
        
        dataTask = defaultSession.dataTask(with: urlRequest, completionHandler: { [weak self] data, response, error  in
            defer {
                self?.dataTask = nil
            }
            
            if let error = error {
                completion(.failure(error))
            } else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                
              DispatchQueue.main.async {
                  completion(.success(data))
              }
            
            }
        })
        
        dataTask?.resume()
    }

}
