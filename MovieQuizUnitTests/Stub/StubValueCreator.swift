//
//  ValueCreator.swift
//  MovieQuizTests
//
//  Created by Avtor_103 on 15.06.2023.
//

import Foundation
@testable import MovieQuiz

class StubValueCreator: ValueCreaterProtocol {
    var mockInt: Int
    var mockBool: Bool
    
    init(mockInt: Int, mockBool: Bool){
        self.mockInt = mockInt
        self.mockBool = mockBool
    }
    
    func getIntValue() -> Int {
        return self.mockInt
    }
    
    func getBoolValue() -> Bool {
        return self.mockBool
    }
}
