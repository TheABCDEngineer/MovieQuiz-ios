//
//  ValueCreatorImpRandom.swift
//  MovieQuiz
//
//  Created by Avtor_103 on 15.06.2023.
//

import Foundation

class ValueCreatorImplRandom: ValueCreaterProtocol {
    func getIntValue() -> Int {
        return Int.random(in: 5..<10)
    }
    
    func getBoolValue() -> Bool {
        return Bool.random()
    }
}
