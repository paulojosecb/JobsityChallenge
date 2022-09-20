//
//  KeychainStorage.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import Foundation
import AuthenticationServices

protocol KeychainStorage {
    var isPinEnabled: Bool { get }
    func create(pin: String, completion: @escaping (Result<Bool, KeychainError>) -> ())
    func update(pin: String, completion: @escaping (Result<Bool, KeychainError>) -> ())
    func validate(pin: String, completion: @escaping (Result<Bool, KeychainError>) -> ())
}

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
}

final class DefaultKeychainStorage: KeychainStorage {
    
    let localStorage: LocalStorage
    
    let pinService = "Jobsity Challenge Pin Service"
    let pinAccount  = "Jobsity Challenge Pin Account"
    
    var isPinEnabled: Bool {
        get {
            return true //self.localStorage.isPinEnabled()
        }
    }
    
    init(localStorage: LocalStorage = DefaultLocalStorage()) {
        self.localStorage = localStorage
    }
    
    func create(pin: String, completion: @escaping (Result<Bool, KeychainError>) -> ()) {
        if pin.count != 4 {
            completion(.failure(.unexpectedPasswordData))
            return
        }
        
        guard let encondedPin = pin.data(using: String.Encoding.utf8) else {
            completion(.failure(.unexpectedPasswordData))
            return
        }
        
        do {
            try self.save(encondedPin, service: pinService, account: pinAccount)
            completion(.success(true))
        } catch _ {
            completion(.failure(.unexpectedPasswordData))
        }
    }
    
    func update(pin: String, completion: @escaping (Result<Bool, KeychainError>) -> ()) {
        if pin.count != 4 {
            completion(.failure(.unexpectedPasswordData))
            return
        }
        
        guard let encondedPin = pin.data(using: String.Encoding.utf8) else {
            completion(.failure(.unexpectedPasswordData))
            return
        }
        
        self.update(encondedPin, service: pinService, account: pinAccount)
        completion(.success(true))
    }
    
    func validate(pin: String, completion: @escaping (Result<Bool, KeychainError>) -> ()) {
        guard let encondedPin = self.read(service: pinService, account: pinAccount),
              let storedPin = String(data: encondedPin, encoding: String.Encoding.utf8) else {
                  completion(.failure(.noPassword))
                  return
              }
        
        completion(.success(storedPin == pin))
    }
    
    private func save(_ data: Data, service: String, account: String) throws {
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary
            
        let saveStatus = SecItemAdd(query, nil)
     
        if saveStatus != errSecSuccess {
            throw KeychainError.unexpectedPasswordData
        }
        
        if saveStatus == errSecDuplicateItem {
            update(data, service: service, account: account)
        }
    }
    
    private func update(_ data: Data, service: String, account: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary
            
        let updatedData = [kSecValueData: data] as CFDictionary
        SecItemUpdate(query, updatedData)
    }
    
    private func read(service: String, account: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: true
        ] as CFDictionary
            
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        return result as? Data
    }
    
}
