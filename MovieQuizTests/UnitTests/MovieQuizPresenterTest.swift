//
//  MovieQuizPresenterTest.swift
//  MovieQuizTests
//
//  Created by Avtor_103 on 14.06.2023.
//

import Foundation
import XCTest
@testable import MovieQuiz

class MovieQuizPresenterTest: XCTestCase {
    let viewConntroller = StubViewController()
    let valueCreator = StubValueCreator(mockInt: 5, mockBool: true)
    
    func testConvertQuestionModelToScreenModel() throws {
        let presenter = initPresenter()
        let mockData = MockConvertData.movies[0]
        let mockQuizQuestionModel = QuizQuestionModel(
            image: Data(),
            movieRank: mockData.movieRank
        )
        
        let expectedQuestionScreenModel = QuestionScreenModel(
            counter: "1/10",
            image: UIImage(data: Data()) ?? UIImage(),
            question: "Рейтинг этого фильма больше чем 5?"
        )
        presenter.onNewQuestionGenerated(model: mockQuizQuestionModel)
        
        let result = viewConntroller.questionScreenModel
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.counter, expectedQuestionScreenModel.counter)
        XCTAssertEqual(result!.image, expectedQuestionScreenModel.image)
        XCTAssertEqual(result!.question, expectedQuestionScreenModel.question)
        
    }
    
    func testAlertOnNetworkFalture() throws {
        let presenter = initPresenter()
        let errorMessage = "Ошибка 123456789"
        
        let expectedAlertModel = AlertScreenModel(
            title: "Что-то пошло не так(",
            message: errorMessage + "\nНевозможно загрузить данные",
            buttonText: "Попробовать еще раз",
            completion: {_ in}
        )
        
        viewConntroller.expectation = expectation(description: "wait for async")
        presenter.onNetworkFailure(errorDescription: errorMessage)
        waitForExpectations(timeout: 2)
        
        let result = viewConntroller.alertScreenModel
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.title, expectedAlertModel.title)
        XCTAssertEqual(result?.message, expectedAlertModel.message)
        XCTAssertEqual(result?.buttonText, expectedAlertModel.buttonText)
    }
    
    func testCreatingCorrectResponse() throws {
        let presenter = initPresenter()
        let trueMovieRating = Float(7.2)
        let qestionMovieRating = 5 //valueCreator.mockInt
        //Вопрос: Рейтинг этого фильма больше чем 5?
        //правильный ответ
        var correctAnswer = Response.yes

        
        let mockQuizQuestionModel = QuizQuestionModel(
            image: Data(),
            movieRank: trueMovieRating
        )
        presenter.onNewQuestionGenerated(model: mockQuizQuestionModel)
        presenter.onButtonClick(userResponse: correctAnswer)
        
        XCTAssertTrue(viewConntroller.isCorrect!)
    }
}
extension MovieQuizPresenterTest {
    func initPresenter() -> MovieQuizPresenter {
        return MovieQuizPresenter(
            viewController: self.viewConntroller,
            questionFactory: StubQuestionFactory(),
            statisticService: StatisticServiceImpl(dataRepository: StubDataRepository()),
            valueCreator: self.valueCreator)
    }
}
