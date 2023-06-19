//
//  NetworkLoaderTest.swift
//  MovieQuizTests
//
//  Created by Avtor_103 on 13.06.2023.
//

import Foundation
import XCTest
@testable import MovieQuiz

class MoviesLoaderTests: XCTestCase {
    func testSuccessLoading() throws {
        let expectedData = MockConvertData.movies
        let moviesLoader = MoviesLoaderImp(
            networkClient: StubNetworkClient(emulateError: false)
        )
        moviesLoader.getMoviesList(
            onSuccess: { result in
                XCTAssertEqual(result.count, 2)
        
                for index in 0...result.count-1 {
                    XCTAssertEqual(result[index].id, expectedData[index].id)
                    XCTAssertEqual(result[index].imageUrl, expectedData[index].imageUrl)
                    XCTAssertEqual(result[index].movieRank, expectedData[index].movieRank)
                }
            },
            onFailure: {_ in
                XCTFail("Неожидаемая ошибка")
            }
        )
    }
    
    func testFailureLoading() throws {
        let networkLoader = MoviesLoaderImp(
            networkClient: StubNetworkClient(emulateError: true)
        )
        networkLoader.getMoviesList(
            onSuccess: {_ in
                XCTFail("Неожидаемая ошибка")
            },
            onFailure: {error in
                XCTAssertEqual(error, MockResponseData.error)
            }
        )
    }
}
