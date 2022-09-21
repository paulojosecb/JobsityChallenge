//
//  HomeViewModel.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import Foundation
import AutoTableView

struct SeriesRowModel: AutoTableViewRowModel {
    let id: Int
    let imageURL: String
    let name: String
    let summary: String
    let rating: String
    let genres: [String]
}

struct SeriesHeaderModel: AutoTableViewHeaderModel {
    var title: String
}

struct SeriesSectionModel: AutoTableViewSectionModel {
    var header: SeriesHeaderModel?
    var rows: [SeriesRowModel]
}

struct SeriesViewModel: AutoTableViewModel {
    var sections: [SeriesSectionModel]
}
