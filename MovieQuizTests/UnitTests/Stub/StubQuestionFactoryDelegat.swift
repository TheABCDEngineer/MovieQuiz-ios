//
//  QuestionFactoryDelegat.swift
//  MovieQuizTests
//
//  Created by Avtor_103 on 15.06.2023.
//

import Foundation
import XCTest
@testable import MovieQuiz

class StubQuestionFactoryDelegat: QuestionFactoryDelegate {
    var expection: XCTestExpectation!
    var isDelegateOnPreparedFactorytSuccess = false
    var isDelegateOnNewQuestionGeneratedSucces = false
    var isDelegateOnNetworkFailureSucces = false
    var questionsCounterRecievedFromFactory = 0
    var quizQuestionModelRecievedFromFactory: QuizQuestionModel?
    
    func onPreparedFactory() {
        isDelegateOnPreparedFactorytSuccess = true
    }
    
    func onNewQuestionGenerated(model: MovieQuiz.QuizQuestionModel?) {
        isDelegateOnNewQuestionGeneratedSucces = true
        questionsCounterRecievedFromFactory += 1
        quizQuestionModelRecievedFromFactory = model
        expection.fulfill()
    }
    
    func onNetworkFailure(errorDescription: String) {
        isDelegateOnNetworkFailureSucces = true
    }
}
