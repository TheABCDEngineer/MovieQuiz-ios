//
//  NetworkLoaderTest.swift
//  MovieQuizTests
//
//  Created by Avtor_103 on 13.06.2023.
//

import Foundation
import XCTest
@testable import MovieQuiz

class NetworkLoaderTests: XCTestCase {
    func testSuccessLoading() throws {
        // Given
        let expectedData = MockConvertData.movies
        let networkLoader = NetworkLoaderImp(
            networkClient: StubNetworkClient(emulateError: false)
        )
        // When
        // Then
        networkLoader.getMoviesList(
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
        // Given
        let networkLoader = NetworkLoaderImp(
            networkClient: StubNetworkClient(emulateError: true)
        )
        // When
        // Then
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
    

