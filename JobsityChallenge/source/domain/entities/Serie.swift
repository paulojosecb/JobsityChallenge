//
//  Serie.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 17/09/22.
//

import Foundation

protocol Entity: Codable {}

struct Serie: Entity, Codable, Equatable {
    let id: Int
    let url: String?
    let name: String?
    let genres: [String]?
    let premiered: String?
    let ended: String?
    let officialSite: String?
    let rating: Rating
    let image: Image?
    let summary: String?
    
    static func == (lhs: Serie, rhs: Serie) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Image: Codable {
    let medium: String?
    let original: String?
}

