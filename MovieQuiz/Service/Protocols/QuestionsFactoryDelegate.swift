import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func onPreparedFactory()
    func onNewQuestionGenerated(model: QuizQuestionModel?)
    func onNetworkFailure(errorDescription: String)
}
