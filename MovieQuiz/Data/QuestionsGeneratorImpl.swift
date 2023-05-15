import Foundation
class QuestionsGeneratorImpl: QuestionsGeneratorProtocol {
    
    func getQuestionsList() -> [QuestionModel] {
        return DataConverter.convertQuestionDtoToModel(
            generateQuestionsList()
        )
    }
    
    private func generateQuestionsList() -> [QuestionDto] {
        let questionsList: [QuestionDto] = [
            QuestionDto (imageTitle: "The Godfather", movieRank: 9.2),
            QuestionDto (imageTitle: "The Dark Knight", movieRank: 9.0),
            QuestionDto (imageTitle: "Kill Bill", movieRank: 8.1),
            QuestionDto (imageTitle: "The Avengers", movieRank: 8.0),
            QuestionDto (imageTitle: "Deadpool", movieRank: 8.0),
            QuestionDto (imageTitle: "The Green Knight", movieRank: 6.6),
            QuestionDto (imageTitle: "Old", movieRank: 5.8),
            QuestionDto (imageTitle: "The Ice Age Adventures of Buck Wild", movieRank: 4.3),
            QuestionDto (imageTitle: "Tesla", movieRank: 5.1),
            QuestionDto (imageTitle: "Vivarium", movieRank: 5.8),
        ]
        return questionsList
    }
}
