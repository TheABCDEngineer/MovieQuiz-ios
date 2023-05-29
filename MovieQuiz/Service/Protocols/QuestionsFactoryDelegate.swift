import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func onNewQuestionsGenerated()
    func onNetworkFailure(errorDescription: String)
}
