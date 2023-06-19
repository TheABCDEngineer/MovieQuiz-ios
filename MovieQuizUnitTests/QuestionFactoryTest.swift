//
//  QuestionFactoryTest.swift
//  MovieQuizTests
//
//  Created by Avtor_103 on 14.06.2023.
//

import Foundation
import XCTest
@testable import MovieQuiz

class QuestionFactoryTest: XCTestCase {
    static let moviesCount = 10
    let dataRepository = StubDataRepository()
    
    func testDelegateSuccessOnPreparedFactory() throws {
        let delegate = StubQuestionFactoryDelegat()
        let moviesLoader = MoviesLoaderImp(
            networkClient: StubNetworkClient(emulateError: false)
        )
        initDataRepository(data: ExpiredMoviesId(items: []))
        let questionFactory = QuestionsFactoryImpl(
            moviesLoader: moviesLoader,
            repository: dataRepository
        )
        questionFactory.addDelegate(delegate: delegate)
        questionFactory.prepareFactory()
        
        XCTAssertTrue(delegate.isDelegateOnPreparedFactorytSuccess)
        XCTAssertFalse(delegate.isDelegateOnNetworkFailureSucces)
        XCTAssertFalse(delegate.isDelegateOnNewQuestionGeneratedSucces)
    }
    
    func testDelegateSuccessOnNewQuestionGenerated() throws {
        let delegate = StubQuestionFactoryDelegat()
        delegate.expection = expectation(description: "async")
        
        let moviesLoader = MoviesLoaderImp(
            networkClient: StubNetworkClient(emulateError: false)
        )
        initDataRepository(data: ExpiredMoviesId(items: []))
        let questionFactory = QuestionsFactoryImpl(
            moviesLoader: moviesLoader,
            repository: dataRepository
        )
      
        questionFactory.addDelegate(delegate: delegate)
        questionFactory.prepareFactory()
        questionFactory.prepareNewQuestionsQueue(questionsQuantity: 2)
        
        waitForExpectations(timeout: 2)

        XCTAssertTrue(delegate.isDelegateOnPreparedFactorytSuccess)
        XCTAssertFalse(delegate.isDelegateOnNetworkFailureSucces)
        XCTAssertTrue(delegate.isDelegateOnNewQuestionGeneratedSucces)
    
    }
    
    func testDelegateSuccessOnNetworkFailure() throws {
        let delegate = StubQuestionFactoryDelegat()
        let moviesLoader = MoviesLoaderImp(
            networkClient: StubNetworkClient(emulateError: true)
        )
 
        let questionFactory = QuestionsFactoryImpl(
            moviesLoader: moviesLoader,
            repository: dataRepository
        )
        
        questionFactory.addDelegate(delegate: delegate)
        questionFactory.prepareFactory()
        
        
        XCTAssertTrue(delegate.isDelegateOnNetworkFailureSucces)
        XCTAssertFalse(delegate.isDelegateOnPreparedFactorytSuccess)
        XCTAssertFalse(delegate.isDelegateOnNewQuestionGeneratedSucces)
    }
    
    func testProvideAllRequredQuestions() throws {
        let moviesCount = QuestionFactoryTest.moviesCount
        let delegate = StubQuestionFactoryDelegat()
        
        var expectations = [XCTestExpectation]()
        for i in 0...moviesCount {
            expectations.append(expectation(description: String(i)))
        }
        
        let moviesLoader = StubMoviesLoader(requaredMoviesCount: moviesCount)

        initDataRepository(data: ExpiredMoviesId(items: []))

        let questionFactory = QuestionsFactoryImpl(
            moviesLoader: moviesLoader,
            repository: dataRepository
        )

        delegate.expection = expectations[0]
        
        questionFactory.addDelegate(delegate: delegate)
        questionFactory.prepareFactory()
        questionFactory.prepareNewQuestionsQueue(questionsQuantity: moviesCount)
        
        for index in 1...moviesCount {
            wait(for: [expectations[index-1]])
            XCTAssertNotNil(delegate.quizQuestionModelRecievedFromFactory)
            XCTAssertEqual(delegate.questionsCounterRecievedFromFactory, index)
            
            delegate.expection = expectations[index]
            questionFactory.getNextQuestion()
        }
        waitForExpectations(timeout: 2)
  
        XCTAssertNil(delegate.quizQuestionModelRecievedFromFactory)
        if delegate.questionsCounterRecievedFromFactory - 1 != moviesCount {
            XCTFail("Количество вопросов, вернувшихся из фабрики, не совпадает с количеством запросов")
        }
    }
}

extension QuestionFactoryTest {
    private func initDataRepository(data: ExpiredMoviesId) {
        dataRepository.saveExpiredMoviesIdList(data)
    }
}
