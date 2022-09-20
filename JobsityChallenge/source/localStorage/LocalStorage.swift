//
//  LocalStorage.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import Foundation

enum LocalStorageError: Error {
    case errorOnOperation
}

protocol LocalStorage {
    func toggleOnFavorite(serie: Serie) throws -> Bool
    func fetchFavorites(completion: @escaping (Result<[Serie], LocalStorageError>) -> ())
}

final class DefaultLocalStorage: LocalStorage {
    let userDefaults: UserDefaults
    let favoriteKey = "FavoriteKey"
    
    init(userDefaults : UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    func toggleOnFavorite(serie: Serie) throws -> Bool {
        guard var series = userDefaults.object(forKey: favoriteKey) as? [Serie] else {
            throw LocalStorageError.errorOnOperation
        }
        
        if let _ = series.firstIndex(of: serie) {
            let filteredSeries = series.filter { $0.id != serie.id }
            userDefaults.set(filteredSeries, forKey: favoriteKey)
            
            return false
        } else {
            series.append(serie)
            userDefaults.set(serie, forKey: favoriteKey)
            
            return true
        }
    }
    
    func fetchFavorites(completion: @escaping (Result<[Serie], LocalStorageError>) -> ()) {
        guard let series = userDefaults.object(forKey: favoriteKey) as? [Serie] else {
            completion(.failure(.errorOnOperation))
            return
        }
        
        completion(.success(series))
    }
    
    
}
