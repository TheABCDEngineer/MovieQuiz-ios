import Foundation

protocol QuestionsFactoryProtocol {
    func addDelegate(delegate: QuestionFactoryDelegate)
    func prepareFactory()
    func prepareNewQuestionsQueue(questionsQuantity: Int)
    func getNextQuestion()
}
