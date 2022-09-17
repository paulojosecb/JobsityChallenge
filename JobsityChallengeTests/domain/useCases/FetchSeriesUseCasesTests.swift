//
//  FetchSeriesUseCasesTests.swift
//  JobsityChallengeTests
//
//  Created by Paulo Barbosa on 17/09/22.
//

import XCTest
@testable import JobsityChallenge

class FetchSeriesUseCasesTests: XCTestCase {

    var sut: FetchSeriesUseCase!
    var repository: FetchSeriesRepository!
    
    override func setUp() {
        repository = MockRepository()
        sut = FetchSeriesUseCase(repository: repository)
    }
    
    override func tearDown() {
        repository = nil
        sut = nil
    }
    
    func testUseCaseWithAllSeries() {
        let expectation = expectation(description: "testUseCaseWithAllSeries")
                
        sut.exec(request: .init(type: .all)) { result in
            switch result {
            case .success(let response):
                if !response.series.isEmpty {
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
                
        sut.exec(request: .init(type: .page(1))) { result in
            switch result {
            case .success(let response):
                if !response.series.isEmpty {
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
        
        sut.exec(request: .init(type: .byName(queryName))) { result in
            switch result {
            case .success(let response):
                let series = response.series.filter { $0.name?.contains(queryName) ?? false }
                
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
        
        sut.exec(request: .init(type: .byName(queryName))) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                guard let error = error as? FetchSeriesError else {
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
                
        sut.exec(request: .init(type: .byId(250))) { result in
            switch result {
            case .success(let response):
                if !response.series.isEmpty && response.series.first?.id == 250 {
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
