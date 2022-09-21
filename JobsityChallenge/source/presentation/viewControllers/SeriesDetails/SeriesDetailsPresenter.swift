//
//  SeriesDetailsPresenter.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import Foundation
import XCTest

protocol SeriesDetailsPresenter {
    func fetchSeriesDetails(id: Int, completion: @escaping (Result<SeriesDetailsView.ViewModel, Error>) -> ())
}

final class DefaultSeriesDetailsPresenter: SeriesDetailsPresenter {
    
    let useCase: FetchEntityUseCase<Serie>
    
    init(useCase: FetchEntityUseCase<Serie> = FetchEntityUseCase()) {
        self.useCase = useCase
    }
    
    func fetchSeriesDetails(id: Int, completion: @escaping (Result<SeriesDetailsView.ViewModel, Error>) -> ()) {
        self.useCase.exec(request: .init(type: .serie(.byId(id)))) { result in
            switch result {
            case .success(let response):
                completion(.success(self.format(serie: response.entities)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func format(serie: Serie) -> SeriesDetailsView.ViewModel {
        return .init(imageUrl: serie.image?.original ?? "",
                     title: serie.name ?? "",
                     summary: serie.summary ?? "")
    }
    
    
}
