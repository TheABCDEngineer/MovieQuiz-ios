import Foundation

protocol StatisticServiceProtocol {
    
    func getStatistic(
        currentGameCorrects: Int,
        currentGameQuestionAmount: Int
    ) -> StatisticModel
    
}
