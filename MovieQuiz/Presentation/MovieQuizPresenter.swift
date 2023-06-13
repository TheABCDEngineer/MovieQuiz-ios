//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Avtor_103 on 13.06.2023.
//

import Foundation

class MovieQuizPresenter: QuestionFactoryDelegate, MovieQuizPresenterProtocol {
    //MARK: - Properties
    private let view: MovieQuizViewControllerProtocol
    private let questionFactory: QuestionsFactoryProtocol
    private let statisticService: StatisticServiceProtocol
    private var questionCounter = 1
    private let totalQuizQuestionsCount = 10
    private var correctResponcesCounter = 0
    private var correctResponse: Response = .yes
    
    //MARK: - Init
    init(
        viewController: MovieQuizViewControllerProtocol,
        questionFactory: QuestionsFactoryProtocol,
        statisticService: StatisticServiceProtocol
    ) {
        self.view = viewController
        self.questionFactory = questionFactory
        self.statisticService = statisticService
        
        questionFactory.addDelegate(delegate: self)
        questionFactory.prepareFactory()
    }
    
    //MARK: - QuestionsFactoryDelegate
    func onPreparedFactory() {
        DispatchQueue.main.async { [weak self] in
            self?.restartQuiz()
        }
    }
    
    func onNewQuestionGenerated(model: QuizQuestionModel?) {
        view.updateLoadingState(isLoading: false)
        if model == nil {
            finishQuiz()
            return
        }
        view.showQuestion(
            model: convertToScreenModel(model: model!)
        )
    }
    
    func onNetworkFailure(errorDescription: String) {
        let alertModel = ScreenModelsCreator.createNetworkFailureAlertScreenModel(
            errorDescription: errorDescription,
            completion: { [weak self] _ in
                guard let self = self else {return}
                self.questionFactory.prepareFactory()
            }
        )
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            view.showAlert(model: alertModel)
        }
    }
    
    //MARK: - MovieQuizPresenterProtocol
    func onButtonClick(userResponse: Response) {
        var isCorrect = false
        if userResponse == correctResponse {
            isCorrect = true
            correctResponcesCounter += 1
        }
        view.showUserResponseResult(isCorrect: isCorrect)
        questionCounter += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {
                return
            }
            self.view.updateLoadingState(isLoading: true)
            self.questionFactory.getNextQuestion()
        }
    }
    
    //MARK: - Private functions
    private func convertToScreenModel(model: QuizQuestionModel) -> QuestionScreenModel {
        let questionMovieRank = Int.random(in: 5..<10)
        let trueIsMoreThanQustion = Bool.random()
        
        correctResponse = getCorrectResponse(
            trueMovieRank: model.movieRank,
            questionMovieRank: questionMovieRank,
            isMore: trueIsMoreThanQustion
        )
        return ScreenModelsCreator.createQuestionScreenModel(
            counter: questionCounter,
            questionAmount: totalQuizQuestionsCount,
            questionMovieRank: questionMovieRank,
            questionImage: model.image,
            trueRankIsMoreThanQuestion: trueIsMoreThanQustion
        )
    }
    
    private func finishQuiz() {
        let statisticModel = statisticService.getStatistic(
            currentGameCorrects: correctResponcesCounter,
            currentGameQuestionAmount: totalQuizQuestionsCount
        )
        let alertModel = ScreenModelsCreator.createQuizFinishedAlertScreenModel(
            correctResponcesCount: correctResponcesCounter,
            questionsCount: totalQuizQuestionsCount,
            statistic: statisticModel,
            completion: { [weak self] _ in
                guard let self = self else {return}
                self.restartQuiz()
            }
        )
        view.showAlert(model: alertModel)
    }
    
    private func restartQuiz() {
        questionCounter = 1
        correctResponcesCounter = 0
        view.updateLoadingState(isLoading: true)
        questionFactory.prepareNewQuestionsQueue(questionsQuantity: totalQuizQuestionsCount)
    }
    
    private func getCorrectResponse(trueMovieRank: Float, questionMovieRank: Int, isMore: Bool) -> Response {
        switch isMore {
        case true:
            if trueMovieRank > Float(questionMovieRank) {
                return .yes
            }
        case false:
            if trueMovieRank < Float(questionMovieRank) {
                return .yes
            }
        }
        return .no
    }
}
