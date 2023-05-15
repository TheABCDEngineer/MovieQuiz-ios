import Foundation

struct Accuracy: Codable {
    let correctsEver: Int
    let questionsAmountEver: Int
    
    func getAccuracy() -> Float {
        if questionsAmountEver == 0 {
            return 0
        }
        return Float(correctsEver)/Float(questionsAmountEver)*100
    }
}
