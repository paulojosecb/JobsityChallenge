//
//  Person.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 21/09/22.
//

import Foundation

struct Person: Entity, Codable {
    let id: Int
    let url: String?
    let name: String?
    let image: Image?
}

struct PersonCastCredits: Entity, Codable {
    let _embedded: PersonCastCreditsEmbedded
}

struct PersonCastCreditsEmbedded: Codable {
    let show: Serie
}
