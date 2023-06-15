//
//  MoviesQuizViewController.swift
//  MovieQuizTests
//
//  Created by Avtor_103 on 15.06.2023.
//

import Foundation
import XCTest
@testable import MovieQuiz

class StubViewController: MovieQuizViewControllerProtocol {
    var expectation: XCTestExpectation!
    var alertScreenModel: AlertScreenModel?
    var questionScreenModel: QuestionScreenModel?
    var isCorrect: Bool?
    
    
    func updateLoadingState(isLoading: Bool) {}
    
    func showAlert(model: MovieQuiz.AlertScreenModel) {
        alertScreenModel = model
        expectation.fulfill()
    }
    
    func showQuestion(model: MovieQuiz.QuestionScreenModel) {
        questionScreenModel = model
    }
    
    func showUserResponseResult(isCorrect: Bool) {
        self.isCorrect = isCorrect
    }
}
