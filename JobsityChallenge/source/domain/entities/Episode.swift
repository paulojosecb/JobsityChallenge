//
//  Episode.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 21/09/22.
//

import Foundation

struct Episode: Entity, Codable {
    let id: Int
    let url: String?
    let name: String?
    let season: Int?
    let number : Int?
    let summary: String?
    let image: Image?
}
