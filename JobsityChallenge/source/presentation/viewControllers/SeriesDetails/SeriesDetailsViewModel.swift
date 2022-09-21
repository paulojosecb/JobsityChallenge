//
//  SeriesDetailsViewModel.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import Foundation
import AutoTableView

struct EpisodesRowModel: AutoTableViewRowModel {
    var id: Int
    var name: String
    var order: Int
}

struct EpisodesHeaderModel: AutoTableViewHeaderModel {
    var title: String
}

struct EpisodesSectionModel: AutoTableViewSectionModel {
    var header: EpisodesHeaderModel?
    var rows: [EpisodesRowModel]
}

struct SeriesDetailsViewModel: AutoTableViewModel {
    var sections: [EpisodesSectionModel]
    
    let imageUrl: String
    let title: String
    let summary: String
    let genres: [String]
    let seasons: [Season]
    
    init(sections: [EpisodesSectionModel]) {
        self.sections = sections
        
        self.imageUrl = ""
        self.title = ""
        self.summary = ""
        self.genres = []
        self.seasons = []
    }
    
    init(sections: [EpisodesSectionModel], imageUrl: String, title: String, summary: String, genres: [String], seasons: [Season]) {
        self.sections = sections
        
        self.imageUrl = imageUrl
        self.title = title
        self.summary = summary
        self.genres = genres
        self.seasons = seasons
    }
}
