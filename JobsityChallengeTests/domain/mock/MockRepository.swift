//
//  MockRepository.swift
//  JobsityChallengeTests
//
//  Created by Paulo Barbosa on 17/09/22.
//

import Foundation
@testable import JobsityChallenge

final class MockRepository: FetchSeriesRepository {
    
    func fetchSeries(with request: FetchSeriesUseCase.Request, completion: @escaping (Result<[Serie], RepositoryError>) -> ()) {
        
        guard let data = getJsonDataFor(file: "Series") else {
            completion(.failure(.network))
            return
        }
        
        guard let series = try? JSONDecoder().decode([Serie].self, from: data) else {
            completion(.failure(.parse))
            return
        }
        
        switch request.type {
        case .page(_), .all:
            completion(.success(series))
            
        case .byName(let name):
            
            let filteredSeries = series.filter { $0.name?.contains(name) ?? false }
            completion(.success(filteredSeries))
            
        case .byId(let id):
            let serie = series.first {$0.id == id }
            
            guard let serie = serie else {
                completion(.failure(.notFound))
                return
            }
            
            completion(.success([serie]))
        }
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
