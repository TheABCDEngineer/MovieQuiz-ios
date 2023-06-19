//
//  QuizStatisticData.swift
//  MovieQuizTests
//
//  Created by Avtor_103 on 15.06.2023.
//

import Foundation
@testable import MovieQuiz

struct MockQuizStatisticData {
    var currentGameCorrects = 4
    var currentGameQuestionAmount = 10
    var quizAmountEver = 30
    var hightScore = HighScore(correct: 5, questionsCount: 10, date: StatisticServiceTest.pastHightScoreDate)
    var accuracy = Accuracy(correctsEver: 20, questionsAmountEver: 30)
}
