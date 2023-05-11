import Foundation
class QuizQuestionsGenerator {
    func generateQuestionList() -> [QuizQuestionDto] {
        let questionsList: [QuizQuestionDto] = [
            QuizQuestionDto (imageTitle: "The Godfather", movieRank: 9.2),
            QuizQuestionDto (imageTitle: "The Dark Knight", movieRank: 9.0),
            QuizQuestionDto (imageTitle: "Kill Bill", movieRank: 8.1),
            QuizQuestionDto (imageTitle: "The Avengers", movieRank: 8.0),
            QuizQuestionDto (imageTitle: "Deadpool", movieRank: 8.0),
            QuizQuestionDto (imageTitle: "The Green Knight", movieRank: 6.6),
            QuizQuestionDto (imageTitle: "Old", movieRank: 5.8),
            QuizQuestionDto (imageTitle: "The Ice Age Adventures of Buck Wild", movieRank: 4.3),
            QuizQuestionDto (imageTitle: "Tesla", movieRank: 5.1),
            QuizQuestionDto (imageTitle: "Vivarium", movieRank: 5.8),
        ]
        return questionsList
    }
}
