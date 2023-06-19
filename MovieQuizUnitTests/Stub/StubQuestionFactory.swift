//
//  QuestionFactory.swift
//  MovieQuizTests
//
//  Created by Avtor_103 on 15.06.2023.
//

import Foundation
@testable import MovieQuiz

class StubQuestionFactory: QuestionsFactoryProtocol {
    func addDelegate(delegate: MovieQuiz.QuestionFactoryDelegate) {}
    
    func prepareFactory() {}
    
    func prepareNewQuestionsQueue(questionsQuantity: Int) {}
    
    func getNextQuestion() {}
}
