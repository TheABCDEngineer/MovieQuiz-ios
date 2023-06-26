//
//  QuestionFactory.swift
//  MovieQuizTests
//
//  Created by Avtor_103 on 15.06.2023.
//

import Foundation
@testable import MovieQuiz

class StubQuestionFactory: QuestionsFactoryProtocol {
    func getQuestionMovieRank(from: Int, to: Int) -> Int {
        return 5
    }
    
    func getIsMore() -> Bool {
        return true
    }
    
    func addDelegate(delegate: MovieQuiz.QuestionFactoryDelegate) {}
    
    func prepareFactory() {}
    
    func prepareNewQuestionsQueue(questionsQuantity: Int) {}
    
    func getNextQuestion() {}
}
