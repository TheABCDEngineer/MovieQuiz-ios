import Foundation

protocol QuestionsFactoryProtocol {
    func addDelegate(delegate: QuestionFactoryDelegate)
    func generateNewQuestions(requiredQuantity: Int)
    func getNextQuestion() -> QuestionModel?
}
