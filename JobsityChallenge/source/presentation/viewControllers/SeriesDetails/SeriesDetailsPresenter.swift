//
//  SeriesDetailsPresenter.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import Foundation
import XCTest

protocol SeriesDetailsPresenter {
    func fetchSeriesDetails(id: Int, completion: @escaping (Result<SeriesDetailsViewModel, Error>) -> ())
    func fetchEpisodesFrom(season: Int, completion: @escaping (Result<SeriesDetailsViewModel, Error>) -> ())
}

final class DefaultSeriesDetailsPresenter: SeriesDetailsPresenter {
    
    let fetchSeriesUseCase: FetchEntityUseCase<Serie>
    let fetchSeasonsUseCase: FetchEntityUseCase<[Season]>
    let fetchEpisodesUseCase: FetchEntityUseCase<[Episode]>

    var currentViewModel: SeriesDetailsViewModel = .init(sections: [], imageUrl: "", title: "", summary: "", genres: [], seasons: [])
    
    init(fetchSeriesUseCase: FetchEntityUseCase<Serie> = FetchEntityUseCase(),
         fetchSeasonsUseCase: FetchEntityUseCase<[Season]> = FetchEntityUseCase(), fetchEpisodesUseCase: FetchEntityUseCase<[Episode]> = FetchEntityUseCase()) {
        
        self.fetchSeriesUseCase = fetchSeriesUseCase
        self.fetchSeasonsUseCase = fetchSeasonsUseCase
        self.fetchEpisodesUseCase = fetchEpisodesUseCase
    }
    
    func fetchSeriesDetails(id: Int, completion: @escaping (Result<SeriesDetailsViewModel, Error>) -> ()) {
        self.fetchSeriesUseCase.exec(request: .init(type: .serie(.byId(id)))) { result in
            switch result {
            case .success(let seriesResponse):
        
                self.fetchSeasonsUseCase.exec(request: .init(type: .season(.bySerie(id)))) { result in
                    switch result {
                    case .success(let seasonResponse):
                        
                        self.currentViewModel = self.format(serie: seriesResponse.entities,
                                                            seasons: seasonResponse.entities)
                        completion(.success(self.currentViewModel))
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchEpisodesFrom(season: Int, completion: @escaping (Result<SeriesDetailsViewModel, Error>) -> ()) {
        self.fetchEpisodesUseCase.exec(request: .init(type: .episode(.fromSeason(season)))) { result in
            switch result {
            case .success(let response):
                self.currentViewModel.sections = [self.format(episodes: response.entities)]
                completion(.success(self.currentViewModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func format(episodes: [Episode]) -> EpisodesSectionModel {
        let episodesRow = episodes.map { EpisodesRowModel(id: $0.id,
                                                          name: $0.name ?? "",
                                                          order: $0.number ?? 1)}
        return .init(header: nil, rows: episodesRow)
    }
    
    private func format(serie: Serie, seasons: [Season]) -> SeriesDetailsViewModel {
        return .init(sections: [],
                     imageUrl: serie.image?.original ?? "",
                     title: serie.name ?? "",
                     summary: serie.summary ?? "",
                     genres: serie.genres ?? [],
                     seasons: seasons)
    }
    
    
}
