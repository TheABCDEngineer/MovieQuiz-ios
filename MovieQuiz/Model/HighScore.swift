import Foundation

struct HighScore: Codable {
    let correct: Int
    let questionsCount: Int
    let date: Date
    
    func getWeight() -> Float {
        if questionsCount == 0 {
            return 0
        }
        return Float(correct)/Float(questionsCount)
    }
}
