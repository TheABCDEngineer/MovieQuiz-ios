//
//  ArrayTest.swift
//  MovieQuizTests
//
//  Created by Avtor_103 on 13.06.2023.
//

import Foundation
import XCTest
@testable import MovieQuiz

class ArrayTest: XCTestCase {
    func testGetValueInRange() throws {
        // Given
        let someArray = [0,1,2,3,4,5,6,7]
        // When
        let value = someArray[safe: 3]
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 3)
    }
    
    func testGetValueOutRange() throws {
        // Given
        let someArray = [0,1,2,3,4,5,6,7]
        // When
        let value = someArray[safe: 20]
        // Then
        XCTAssertNil(value)
    }
}
