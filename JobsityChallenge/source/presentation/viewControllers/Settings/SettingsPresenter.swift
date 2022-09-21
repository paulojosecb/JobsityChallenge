//
//  SettingsPresenter.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 21/09/22.
//

import Foundation

protocol SettingsPresenter {
    func isTouchIDEnabled() -> Bool
    func isPinEnabled() -> Bool
    
    func toggleTouchID(newValue: Bool) -> Bool
    func togglePin(newValue: Bool) -> Bool
    
    func setNewPin(pin: String, completion: @escaping (Result<Bool, Error>) -> ())
    
    func delete(completion: @escaping (Result<Bool, Error>) -> ())

}

final class DefaultSettingsPresenter: SettingsPresenter {
    
    let localStorage: LocalStorage
    let keychainStorage: KeychainStorage
    
    init(localStorage: LocalStorage = DefaultLocalStorage(),
         keychainStorage: KeychainStorage = DefaultKeychainStorage()) {
        self.localStorage = localStorage
        self.keychainStorage = keychainStorage
    }
    
    
    func isTouchIDEnabled() -> Bool {
        return localStorage.isTouchIDEnabled()
    }
    
    func isPinEnabled() -> Bool {
        return localStorage.isPinEnabled()
    }
    
    func toggleTouchID(newValue: Bool) -> Bool {
        localStorage.setTouchIDEnabled(enable: newValue)
        return newValue
    }
    
    func togglePin(newValue: Bool) -> Bool {
        localStorage.setPinEnabled(enable: newValue)
        return newValue
    }
    
    func setNewPin(pin: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        keychainStorage.create(pin: pin) { result in
            switch result {
            case .success(let created):
                completion(.success(created))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func delete(completion: @escaping (Result<Bool, Error>) -> ()) {
        keychainStorage.delete { result in
            switch result {
            case .success(let deleted):
                completion(.success(deleted))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}
