//
//  StatisticServiceTest.swift
//  MovieQuizTests
//
//  Created by Avtor_103 on 13.06.2023.
//

import Foundation
import XCTest
@testable import MovieQuiz

class StatisticServiceTest: XCTestCase {
    static let pastHightScoreDate = Date(timeIntervalSinceNow: -20000000.0)
    let dataRepository = StubDataRepository()
    
    func testProvideStatisticModelWithoutNewHightScore() throws {
        let mockData = MockQuizStatisticData()
        initDataRepository(data: mockData)
        
        let expectedStatisticModel = StatisticModel(
            quizAmountEver: mockData.quizAmountEver + 1,
            highScore: mockData.hightScore,
            accuracy: Accuracy(
                correctsEver: mockData.accuracy.correctsEver + mockData.currentGameCorrects,
                questionsAmountEver: mockData.accuracy.questionsAmountEver + mockData.currentGameQuestionAmount
            )
        )
        
        let statisticService = StatisticServiceImpl(
            dataRepository: dataRepository
        )
        let result = statisticService.getStatistic(
            currentGameCorrects: mockData.currentGameCorrects,
            currentGameQuestionAmount: mockData.currentGameQuestionAmount
        )
        XCTAssertEqual(result.quizAmountEver, expectedStatisticModel.quizAmountEver)
        XCTAssertEqual(result.highScore.correct, expectedStatisticModel.highScore.correct)
        XCTAssertEqual(result.highScore.questionsCount, expectedStatisticModel.highScore.questionsCount)
        XCTAssertEqual(result.highScore.date, expectedStatisticModel.highScore.date)
        XCTAssertEqual(result.accuracy.correctsEver, expectedStatisticModel.accuracy.correctsEver)
        XCTAssertEqual(result.accuracy.questionsAmountEver, expectedStatisticModel.accuracy.questionsAmountEver)
    }
    
    func testProvideStatisticModelWithNewHightScore() throws {
        var mockData = MockQuizStatisticData()
        initDataRepository(data: mockData)
        mockData.currentGameCorrects = mockData.hightScore.correct + 1
        
        let expectedStatisticModel = StatisticModel(
            quizAmountEver: mockData.quizAmountEver + 1,
            highScore: HighScore(
                correct: mockData.currentGameCorrects,
                questionsCount: mockData.currentGameQuestionAmount,
                date: Date()
            ),
            accuracy: Accuracy(
                correctsEver: mockData.accuracy.correctsEver + mockData.currentGameCorrects,
                questionsAmountEver: mockData.accuracy.questionsAmountEver + mockData.currentGameQuestionAmount
            )
        )
        
        let statisticService = StatisticServiceImpl(
            dataRepository: dataRepository
        )
        let result = statisticService.getStatistic(
            currentGameCorrects: mockData.currentGameCorrects,
            currentGameQuestionAmount: mockData.currentGameQuestionAmount
        )
        XCTAssertEqual(result.quizAmountEver, expectedStatisticModel.quizAmountEver)
        XCTAssertEqual(result.highScore.correct, expectedStatisticModel.highScore.correct)
        XCTAssertEqual(result.highScore.questionsCount, expectedStatisticModel.highScore.questionsCount)
        XCTAssertGreaterThan(result.highScore.date, StatisticServiceTest.pastHightScoreDate)
        XCTAssertLessThanOrEqual(result.highScore.date, Date())
        XCTAssertEqual(result.accuracy.correctsEver, expectedStatisticModel.accuracy.correctsEver)
        XCTAssertEqual(result.accuracy.questionsAmountEver, expectedStatisticModel.accuracy.questionsAmountEver)
    }
    
    func testSaveStatisticToRepository() throws {
        var mockData = MockQuizStatisticData()
        initDataRepository(data: mockData)
        mockData.currentGameCorrects = mockData.hightScore.correct + 1
        
        let expectedSavedQuizAmount = mockData.quizAmountEver + 1
        let expectedSavedNewHightScore = HighScore(
            correct: mockData.currentGameCorrects,
            questionsCount: mockData.currentGameQuestionAmount,
            date: Date()
        )
        let expectedSavedAccuracy = Accuracy(
            correctsEver: mockData.accuracy.correctsEver + mockData.currentGameCorrects,
            questionsAmountEver: mockData.accuracy.questionsAmountEver + mockData.currentGameQuestionAmount
        )
        
        let statisticService = StatisticServiceImpl(
            dataRepository: dataRepository
        )
        let _ = statisticService.getStatistic(
            currentGameCorrects: mockData.currentGameCorrects,
            currentGameQuestionAmount: mockData.currentGameQuestionAmount
        )
        XCTAssertEqual(dataRepository.loadQuizAmountEver(), expectedSavedQuizAmount)
        XCTAssertEqual(dataRepository.loadHighScore().correct, expectedSavedNewHightScore.correct)
        XCTAssertEqual(dataRepository.loadHighScore().questionsCount, expectedSavedNewHightScore.questionsCount)
        XCTAssertGreaterThan(dataRepository.loadHighScore().date, StatisticServiceTest.pastHightScoreDate)
        XCTAssertLessThanOrEqual(dataRepository.loadHighScore().date, Date())
        XCTAssertEqual(dataRepository.loadAccuracy().correctsEver, expectedSavedAccuracy.correctsEver)
        XCTAssertEqual(dataRepository.loadAccuracy().questionsAmountEver, expectedSavedAccuracy.questionsAmountEver)
    }
}

extension StatisticServiceTest {
    private func initDataRepository(data: MockQuizStatisticData) {
        dataRepository.saveQuizAmountEver(data.quizAmountEver)
        dataRepository.saveHighScore(data.hightScore)
        dataRepository.saveAccuracy(data.accuracy)
    }
}
