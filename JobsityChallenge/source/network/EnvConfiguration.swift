//
//  EnvConfiguration.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 21/09/22.
//

import Foundation

enum EnvConfiguration {
    
    static var apiBaseURL: String {
        string(for: "BASE_URL")
    }
    
    static private func string(for key: String) -> String {
        Bundle.main.infoDictionary?[key] as! String
    }
}
