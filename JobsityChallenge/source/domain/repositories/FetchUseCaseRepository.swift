//
//  FetchUseCaseRepository.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 17/09/22.
//

import Foundation

protocol FetchSeriesRepository {
    func fetchSeries(with request: FetchSeriesUseCase.Request, completion: @escaping (Result<[Serie], RepositoryError>) -> ())
}
