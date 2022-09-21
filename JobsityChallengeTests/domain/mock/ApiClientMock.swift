//
//  ApiClientMock.swift
//  JobsityChallengeTests
//
//  Created by Paulo Barbosa on 21/09/22.
//

import Foundation
@testable import JobsityChallenge

final class APIClientMock: APIClient {
    
    func requestJSON<T>(urlRequest: URLRequest, completion: @escaping (Result<T, RequestError>) -> Void) where T : Decodable, T : Encodable {
        
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
        
        guard let data = getJsonDataFor(file: "Series") else {
            completion(.failure(RequestError.noData))
            return
        }
        
        completion(.success(data))
        
    }
    
    private func getJsonDataFor(file: String) -> Data? {
        guard let path = Bundle.main.path(forResource: file, ofType: "json") else { return nil
        }

        let url = URL(fileURLWithPath: path)

        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            return nil
        }
    }

}
