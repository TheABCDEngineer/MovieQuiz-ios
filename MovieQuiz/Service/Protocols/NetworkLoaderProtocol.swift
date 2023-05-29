import Foundation

protocol NetworkLoaderProtocol {
    func getQuestionsList(
        onSuccess: @escaping ([QuestionModel]) -> Void,
        onFailure: @escaping (String) -> Void
    )
}
