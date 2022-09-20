//
//  RouterFactory.swift
//  JobsityChallenge
//
//  Created by Paulo Barbosa on 20/09/22.
//

import Foundation

final class RouterFactory {
        
    static func makeRouter<T: Codable>(for requestType: FetchEntityUseCase<T>.RequestType) -> Router? {
        
        switch requestType {
        case .episode(let episodeRequest):
            return self.makeRouter(for: episodeRequest)
        case .person(let personRequest):
            return self.makeRouter(for: personRequest)
        case .serie(let seasonRequest):
            return self.makeRouter(for: seasonRequest)
        }
    }
    
    private static func makeRouter<T: Codable>(for requestType: FetchEntityUseCase<T>.EpisodeRequestType) -> EpisodeRouter? {
        
        switch requestType {
        case .fromSerie(let id):
            return EpisodeRouter.fromSerie(id)
        case .byId(let id):
            return EpisodeRouter.byId(id)
        }
        
    }
    
    private static func makeRouter<T: Codable>(for requestType: FetchEntityUseCase<T>.SerieRequestType) -> SerieRouter? {

        switch requestType {
        case .byName(let name):
            return SerieRouter.byName(name)
        case .byId(let id):
            return SerieRouter.byId(id)
        case .all:
            return SerieRouter.all
        case .paged(let page):
            return SerieRouter.paged(page)
        }
        
    }
    
    private static func makeRouter<T: Codable>(for requestType: FetchEntityUseCase<T>.PersonRequestType) -> PersonRouter? {
        
        switch requestType {
        case .byId(let id):
            return PersonRouter.byId(id)
        case .byName(let name):
            return PersonRouter.byName(name)
        case .credits(let id):
            return PersonRouter.credits(id)
        }
        
    }
    
}

