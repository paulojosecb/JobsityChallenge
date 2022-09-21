//
//  HomePresenter.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import Foundation

protocol SeriesPresenter {
    
    var searchResult: SeriesViewModel { get }
    var generalResult: SeriesViewModel { get }
    
    func fetchNextPage(completion: @escaping (Result<SeriesViewModel, Error>) -> ())
    func fetchSeriesBy(query: String, completion: @escaping (Result<SeriesViewModel, Error>) -> ())
}

final class DefaultSeriesPresenter: SeriesPresenter {
    
    private lazy var currentPage = 1
    private let useCase: FetchEntityUseCase<[Serie]>
    
    var searchResult: SeriesViewModel
    var generalResult: SeriesViewModel
    
    init(useCase: FetchEntityUseCase<[Serie]> = FetchEntityUseCase<[Serie]>()) {
        self.generalResult = .init(sections: [])
        self.searchResult = .init(sections: [])
        self.useCase = useCase
    }
    
    func fetchNextPage(completion: @escaping (Result<SeriesViewModel, Error>) -> ()) {
        self.useCase.exec(request: .init(type: .serie(.paged(self.currentPage)))) { result in
            switch result {
            case .success(let response):
                let viewModel = self.format(series: response.entities)
                self.generalResult = viewModel
                completion(.success(viewModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchSeriesBy(query: String, completion: @escaping (Result<SeriesViewModel, Error>) -> ()) {
        self.useCase.exec(request: .init(type: .serie(.byName(query)))) { result in
            switch result {
            case .success(let response):
                let viewModel = self.format(series: response.entities)
                self.searchResult = viewModel
                completion(.success(viewModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func format(series: [Serie]) -> SeriesViewModel {
        let seriesRow = series.map { SeriesRowModel.init(imageURL: $0.image?.medium ?? "",
                                                         name: $0.name ?? "",
                                                         summary: $0.summary ?? "",
                                                         rating: $0.rating.average != nil ? "\($0.rating.average!)/10" : "Not rated",
                                                         genres: $0.genres ?? [])}
        return .init(sections: [
            .init(header: nil,
                  rows: seriesRow)
        ])
    }
    
}
