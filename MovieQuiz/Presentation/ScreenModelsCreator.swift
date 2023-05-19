import UIKit
class ScreenModelsCreator {
    
    static func createQuestionScreenModel(
        counter: Int,
        questionCount: Int,
        questionMovieRank: Int,
        questionImageUrl: String
    ) -> QuestionScreenModel {
        
        return QuestionScreenModel(
            counter: String(counter) + "/" + String(questionCount),
            image: UIImage(named: questionImageUrl) ?? UIImage(),
            question: "Рейтинг этого фильма больше чем " + String(questionMovieRank) + "?"
        )
    }
    
    static func createAlertScreenModel(
        correctResponcesCount: Int,
        questionsCount: Int,
        statistic: StatisticModel,
        completion: @escaping (UIAlertAction) -> Void
    ) -> AlertScreenModel {
        
        let currentResultString = "Ваш результат: "
            + String(correctResponcesCount)
            + "/" + String(questionsCount)
        
        let quizAmountString = "Количество сыгранных квизов: "
            + String(statistic.quizAmountEver)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YY HH:mm"
        
        let highScore = statistic.highScore
        let highScoreString = "Рекорд: "
            + String(highScore.correct)
            + "/" + String(highScore.questionsCount)
            + " (" + dateFormatter.string(from: highScore.date) + ")"
        
        let accuracy = statistic.accuracy
        let accuracyString = "Средняя точность: "
            + String(format: "%.2f", accuracy.getAccuracy()) + "%"
        
        let message = currentResultString + "\n"
            + quizAmountString + "\n"
            + highScoreString + "\n"
            + accuracyString
        
        return AlertScreenModel(
            title: "Этот радунд окончен!",
            message: message,
            buttonText: "Сыграть ещё раз",
            completion: completion
        )
    }
}

