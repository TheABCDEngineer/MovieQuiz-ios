import UIKit
class ScreenModelsCreator {
    
    static func createQuestionScreenModel(
        counter: Int,
        questionAmount: Int,
        questionMovieRank: Int,
        questionImage: Data,
        trueRankIsMoreThanQuestion: Bool
    ) -> QuestionScreenModel {
        var subQuestion = "меньше"
        if trueRankIsMoreThanQuestion {
            subQuestion = "больше"
        }
        
        return QuestionScreenModel(
            counter: String(counter) + "/" + String(questionAmount),
            image: UIImage(data: questionImage) ?? UIImage(),
            question: "Рейтинг этого фильма " + subQuestion + " чем " + String(questionMovieRank) + "?"
        )
    }
    
    static func createQuizFinishedAlertScreenModel(
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
    
    static func createNetworkFailureAlertScreenModel(
        errorDescription: String,
        completion: @escaping (UIAlertAction) -> Void
    ) -> AlertScreenModel {
        let message = errorDescription
        + "\nНевозможно загрузить данные"
        
        return AlertScreenModel(
            title: "Что-то пошло не так(",
            message: message,
            buttonText: "Попробовать еще раз",
            completion: completion
        )
    }
}

