//
//  Serie.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 17/09/22.
//

import Foundation

struct Serie: Codable {
    let id: Int
    let url: String?
    let name: String?
    let genres: [String]?
    let premiered: String?
    let ended: String?
    let officialSite: String?
    let rating: Rating
    let image: Image
    let summary: String?
}

struct Rating: Codable {
    let average: Double?
}

struct Image: Codable {
    let medium: String?
    let original: String?
}
