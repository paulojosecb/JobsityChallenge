//
//  Season.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 21/09/22.
//

import Foundation

struct Season: Entity, Codable {
    let id: Int
    let number: Int?
    let episodeOrder: Int?
}
