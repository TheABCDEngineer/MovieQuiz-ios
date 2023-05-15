import Foundation

class StatisticServiceImpl: StatisticServiceProtocol {
    
    private var isHighScore = false
    private let dataRepository: StatisticDataRepository
    init(dataRepository: StatisticDataRepository) {
        self.dataRepository = dataRepository
    }
    
    func getStatistic(
        currentGameCorrects: Int,
        currentGameQuestionAmount: Int
    ) -> StatisticModel {
        
        let quizAmountEver = provideQuizAmoutEverValue()
        
        let highScore = provideHighScoreValue(
            currentGameCorrects: currentGameCorrects,
            currentGameQuestionAmount: currentGameQuestionAmount
        )
        let accuracy = provideAccuracyValue(
            currentGameCorrects: currentGameCorrects,
            currentGameQuestionAmount: currentGameQuestionAmount
        )
        let statisticModel = StatisticModel(
            quizAmountEver: quizAmountEver,
            highScore: highScore,
            accuracy: accuracy
        )
        saveUpdStatistic(statisticModel)
        return statisticModel
    }
    
    private func provideQuizAmoutEverValue() -> Int {
        var quizAmount = dataRepository.loadQuizAmountEver()
        quizAmount += 1
        
        return quizAmount
    }
    
    private func provideHighScoreValue(
        currentGameCorrects: Int,
        currentGameQuestionAmount: Int
    ) -> HighScore {
        
        let currentScore = HighScore(
            correct: currentGameCorrects,
            questionsCount: currentGameQuestionAmount,
            date: Date()
        )
        var highScore = dataRepository.loadHighScore()
        isHighScore = false
        
        if currentScore.getWeight() > highScore.getWeight() {
            highScore = currentScore
            isHighScore = true
        }
        return highScore
    }
    
    private func provideAccuracyValue(
        currentGameCorrects: Int,
        currentGameQuestionAmount: Int
    ) -> Accuracy {
        
        let historyAccuracy = dataRepository.loadAccuracy()
        let updCorrectsEver = historyAccuracy.correctsEver + currentGameCorrects
        let updQuestionsAmountEver = historyAccuracy.questionsAmountEver + currentGameQuestionAmount
        
        let updAccuracy = Accuracy(
            correctsEver: updCorrectsEver,
            questionsAmountEver: updQuestionsAmountEver
        )
        return updAccuracy
    }
    
    private func saveUpdStatistic(_ model: StatisticModel) {
        dataRepository.saveQuizAmountEver(model.quizAmountEver)
        dataRepository.saveAccuracy(model.accuracy)
        if isHighScore {
            dataRepository.saveHighScore(model.highScore)
        }
        
    }
}
