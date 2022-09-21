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
              var series = try? PropertyListDecoder().decode([Serie].self, from: data) else {
            
                  if let data = try? PropertyListEncoder().encode([serie]) {
                      userDefaults.set(data, forKey: favoriteKey)
                      return true
                  } else {
                      throw LocalStorageError.errorOnOperation
                  }

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
        guard let data = userDefaults.data(forKey: favoriteKey),
              let series = try? PropertyListDecoder().decode([Serie].self, from: data) else {
                  completion(.success([]))
                  return
        }
        
        completion(.success(series))
    }
    
    
}
