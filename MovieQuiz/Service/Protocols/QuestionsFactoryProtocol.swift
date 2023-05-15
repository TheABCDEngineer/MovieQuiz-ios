import Foundation

protocol QuestionsFactoryProtocol {
    func addDelegate(delegate: QuestionFactoryDelegate)
    func generateNewQuestions()
    func getNextQuestion() -> QuestionModel?
    func getQuestionsCount() -> Int
}
