import Foundation

class StatisticDataRepositoryImplUserDefaults: StatisticDataRepository {
    private let userDefaults = UserDefaults.standard
    
    private func saveJSONOnKey(codable: Codable, key: String) {
        guard let data = try? JSONEncoder().encode(codable) else {
            print("Невозможно сохранить результат")
            return
        }
        userDefaults.set(data, forKey: key)
    }
    
    func saveQuizAmountEver(_ value: Int) {
        userDefaults.set(value, forKey: Key.quizAmountEver.rawValue)
    }
    
    func saveHighScore(_ value: HighScore) {
        saveJSONOnKey(codable: value, key: Key.highScore.rawValue)
    }
    
    func saveAccuracy(_ value: Accuracy) {
        saveJSONOnKey(codable: value, key: Key.accuracy.rawValue)
    }
    
    func loadQuizAmountEver() -> Int {
        return userDefaults.integer(forKey: Key.quizAmountEver.rawValue)
    }
    
    func loadHighScore() -> HighScore {
        guard let data = userDefaults.data(forKey: Key.highScore.rawValue),
              let record = try? JSONDecoder().decode(HighScore.self, from: data) else {
            return .init(correct: 0, questionsCount: 0, date: Date())
        }
        return record
    }
    
    func loadAccuracy() -> Accuracy {
        guard let data = userDefaults.data(forKey: Key.accuracy.rawValue),
              let record = try? JSONDecoder().decode(Accuracy.self, from: data) else {
            return .init(correctsEver: 0, questionsAmountEver: 0)
        }
        return record
    }
}

extension StatisticDataRepositoryImplUserDefaults {
    private enum Key: String {
        case quizAmountEver
        case highScore
        case accuracy
    }
}
