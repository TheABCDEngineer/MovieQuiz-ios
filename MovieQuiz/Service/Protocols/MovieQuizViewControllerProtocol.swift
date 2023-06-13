//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Avtor_103 on 13.06.2023.
//

import Foundation

protocol MovieQuizViewControllerProtocol {
    func updateLoadingState(isLoading: Bool)
    func showAlert(model: AlertScreenModel)
    func showQuestion(model: QuestionScreenModel)
    func showUserResponseResult(isCorrect: Bool)
}
