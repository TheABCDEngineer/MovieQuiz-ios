import Foundation

protocol StatisticDataRepository {
    func saveQuizAmountEver(_ value: Int)
    func saveHighScore(_ value: HighScore)
    func saveAccuracy(_ value: Accuracy)
    
    func loadQuizAmountEver() -> Int
    func loadHighScore() -> HighScore
    func loadAccuracy() -> Accuracy
}
