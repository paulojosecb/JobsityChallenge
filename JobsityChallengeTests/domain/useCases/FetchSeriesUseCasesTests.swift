//
//  FetchSeriesUseCasesTests.swift
//  JobsityChallengeTests
//
//  Created by Paulo Barbosa on 17/09/22.
//

import XCTest
@testable import JobsityChallenge

class FetchSeriesUseCasesTests: XCTestCase {

    var sut: FetchEntityUseCase<[Serie]>!
    var repository: EntityRepository!
    
    override func setUp() {
        repository = EntityRepository(apiClient: APIClientMock())
        sut = FetchEntityUseCase(repository: repository)
    }
    
    override func tearDown() {
        repository = nil
        sut = nil
    }
    
    func testUseCaseWithAllSeries() {
        let expectation = expectation(description: "testUseCaseWithAllSeries")
        
        sut.exec(request: .init(type: .serie(.all))) { result in
            switch result {
            case .success(let response):
                if !response.entities.isEmpty {
                    expectation.fulfill()
                } else {
                    XCTFail()
                }
            case .failure(_):
                XCTFail()
            }
        }

        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testUseCaseWithPagedRequest() {
        let expectation = expectation(description: "testUseCaseWithPagedRequest")
                
        sut.exec(request: .init(type: .serie(.paged(1)))) { result in
            switch result {
            case .success(let response):
                if !response.entities.isEmpty {
                    expectation.fulfill()
                } else {
                    XCTFail()
                }
            case .failure(_):
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testUseCaseWithBynameRequest() {
        let expectation = expectation(description: "testUseCaseWithBynameRequest")
                
        let queryName = "Downton"
        
        sut.exec(request: .init(type: .serie(.byName(queryName)))) { result in
            switch result {
            case .success(let response):
                let series = response.entities.filter { $0.name?.contains(queryName) ?? false }
                
                if !series.isEmpty {
                    expectation.fulfill()
                } else {
                    XCTFail()
                }
            case .failure(_):
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testUseCaseWithInvalidBynameRequest() {
        let expectation = expectation(description: "testUseCaseWithBynameRequest")
                
        let queryName = ""
        
        sut.exec(request: .init(type: .serie(.byName(queryName)))) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                guard let error = error as? FetchEntityError else {
                    XCTFail()
                    return
                }
                
                if error == .invalidName {
                    expectation.fulfill()
                }
            }
        }
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testUseCaseWithByIdRequest() {
        let expectation = expectation(description: "testUseCaseWithByIdRequest")
                
        sut.exec(request: .init(type: .serie(.byId(250)))) { result in
            switch result {
            case .success(let response):
                if !response.entities.isEmpty && response.entities.first?.id == 250 {
                    expectation.fulfill()
                } else {
                    XCTFail()
                }
            case .failure(_):
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }

}
