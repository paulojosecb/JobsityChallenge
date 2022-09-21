//
//  EpisodeDetailsPresenter.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 21/09/22.
//

import Foundation

protocol EpisodeDetailsPresenter {
    func fetchEpisodeDetails(id: Int, completion: @escaping (Result<EpisodeDetailsViewModel, Error>) -> ())
}

final class DefaultEpisodeDetailsPresenter: EpisodeDetailsPresenter {
    
    let useCase: FetchEntityUseCase<Episode>
    
    init(useCase: FetchEntityUseCase<Episode> = FetchEntityUseCase<Episode>()) {
        self.useCase = useCase
    }
    
    func fetchEpisodeDetails(id: Int, completion: @escaping (Result<EpisodeDetailsViewModel, Error>) -> ()) {
        self.useCase.exec(request: .init(type: .episode(.byId(id)))) { result in
            switch result {
            case .success(let response):
                completion(.success(self.format(episode: response.entities)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func format(episode: Episode) -> EpisodeDetailsViewModel {
        return .init(imageUrl: episode.image?.original ?? "",
                     title: episode.name ?? "",
                     number: episode.number ?? 0,
                     season: episode.season ?? 0,
                     summary: episode.summary ?? "")
    }
}
