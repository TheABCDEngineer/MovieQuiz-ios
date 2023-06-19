//
//  StatisticDataRepository.swift
//  MovieQuizTests
//
//  Created by Avtor_103 on 15.06.2023.
//

import Foundation
@testable import MovieQuiz

class StubDataRepository: StatisticDataRepository {
    
    private var savedData = [String: Any]()
    private let key = StatisticDataRepositoryImplUserDefaults.Key.self
    
    func saveQuizAmountEver(_ value: Int) {
        savedData[key.quizAmountEver.rawValue] = value
    }
    
    func saveHighScore(_ value: MovieQuiz.HighScore) {
        savedData[key.highScore.rawValue] = value
    }
    
    func saveAccuracy(_ value: MovieQuiz.Accuracy) {
        savedData[key.accuracy.rawValue] = value
    }
    
    func saveExpiredMoviesIdList(_ value: MovieQuiz.ExpiredMoviesId) {
        savedData[key.expiredId.rawValue] = value
    }
    
    func loadQuizAmountEver() -> Int {
        return savedData[key.quizAmountEver.rawValue] as! Int
    }
    
    func loadHighScore() -> MovieQuiz.HighScore {
        return savedData[key.highScore.rawValue] as! HighScore
    }
    
    func loadAccuracy() -> MovieQuiz.Accuracy {
        return savedData[key.accuracy.rawValue] as! Accuracy
    }
    
    func loadExpiredMoviesIdList() -> MovieQuiz.ExpiredMoviesId {
        return savedData[key.expiredId.rawValue] as! ExpiredMoviesId
    }
}
