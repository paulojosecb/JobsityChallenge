//
//  RepositoryError.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 17/09/22.
//

import Foundation

enum RepositoryError: Error {
    case network
    case unknown
    case parse
    case notFound
}

enum AuthenticationRepositoryError: Error {
    case wrongPin
    case localAuthUnavailable
    case unknown
}
