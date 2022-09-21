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
    func isPinEnabled() -> Bool
    func setPinEnabled(enable: Bool)
    func isTouchIDEnabled() -> Bool
    func setTouchIDEnabled(enable: Bool)
    func toggleOnFavorite(serie: Serie) throws -> Bool
    func isSerieFavorite(serie: Serie) -> Bool
    func fetchFavorites(completion: @escaping (Result<[Serie], LocalStorageError>) -> ())
}

final class DefaultLocalStorage: LocalStorage {

    let userDefaults: UserDefaults
    
    let favoriteKey = "FavoriteKey"
    let isPinEnabledKey = "isPinEnabled"
    let isTouchID = "isTouchIDEnabled"
    
    init(userDefaults : UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    func isPinEnabled() -> Bool {
        return userDefaults.bool(forKey: isPinEnabledKey)
    }
    
    func setPinEnabled(enable: Bool) {
        userDefaults.set(enable, forKey: isPinEnabledKey)
    }
    
    func isTouchIDEnabled() -> Bool {
        return userDefaults.bool(forKey: isTouchID)
    }
    
    func setTouchIDEnabled(enable: Bool) {
        userDefaults.set(enable, forKey: isTouchID)
    }
    
    func toggleOnFavorite(serie: Serie) throws -> Bool {
        guard let data = userDefaults.data(forKey: favoriteKey),
              var series = self.decode(data: data) else {
            
                  if let data = encode(series: [serie]){
                      userDefaults.set(data, forKey: favoriteKey)
                      return false
                  } else {
                      throw LocalStorageError.errorOnOperation
                  }
        }
        
        if let _ = series.firstIndex(of: serie) {
            let filteredSeries = series.filter { $0.id != serie.id }
            
            if let data = encode(series: filteredSeries){
                userDefaults.set(data, forKey: favoriteKey)
                return false
            } else {
                throw LocalStorageError.errorOnOperation
            }
            
        } else {
            
            series.append(serie)
            
            if let data = encode(series: series){
                userDefaults.set(data, forKey: favoriteKey)
                return true
            } else {
                throw LocalStorageError.errorOnOperation
            }
                        
        }
    }
    
    func fetchFavorites(completion: @escaping (Result<[Serie], LocalStorageError>) -> ()) {
        completion(.success(self.getSeriesFromUserDefaults()))
    }
    
    func isSerieFavorite(serie: Serie) -> Bool {
        return getSeriesFromUserDefaults().contains(serie)
    }
    
    func getSeriesFromUserDefaults() -> [Serie] {
        guard let data = userDefaults.data(forKey: favoriteKey),
              let series = try? PropertyListDecoder().decode([Serie].self, from: data) else {
                  return []
        }
        
        return series
    }
    
    private func encode(series: [Serie]) -> Data? {
        return try? PropertyListEncoder().encode(series)
    }
    
    private func decode(data: Data) -> [Serie]? {
        return try? PropertyListDecoder().decode([Serie].self, from: data)
    }
    
    
}
