import Foundation

class QuestionsFactoryImpl: QuestionsFactoryProtocol {
    private let networkLoader: NetworkLoaderProtocol
    private let repository: StatisticDataRepository
    private var questions = [QuestionModel]()
    private var requaredQuestionsQuantity = 0
    private var questionsCount = 0
    private var expiredQuestions = ExpiredMoviesId(items: [])
    private weak var delegate: QuestionFactoryDelegate?
    
    init(
        networkLoader: NetworkLoaderProtocol,
        repository: StatisticDataRepository
    ) {
        self.networkLoader = networkLoader
        self.repository = repository
    }
    
    func addDelegate(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    func generateNewQuestions(requiredQuantity: Int) {
        requaredQuestionsQuantity = requiredQuantity
        questionsCount = 0
        
        if questions.isEmpty {
            networkLoader.getQuestionsList(
                onSuccess: { [weak self] questionsList in
                    DispatchQueue.main.async {
                        self?.prepareNewQuestionsList(questionsList)
                    }
                },
                onFailure: { [weak self] error in
                    DispatchQueue.main.async {
                        self?.delegate?.onNetworkFailure(errorDescription: error)
                    }
                }
            )
        } else {
            prepareNewQuestionsList(nil)
        }
    }
    
    func getNextQuestion() -> QuestionModel? {
        if (questionsCount == requaredQuestionsQuantity)  {
            repository.saveExpiredQuestionsIdList(expiredQuestions)
            return nil
        }
        var randomIndex = 0
        repeat {
            randomIndex = Int.random(in: 0..<questions.count)
        } while checkQuestionIdIsExpired(
            questions[randomIndex].id
        )
        
        expiredQuestions.items.append(
            questions[randomIndex].id
        )
        questionsCount += 1
        return questions[randomIndex]
    }
  
    private func prepareNewQuestionsList(_ questionsList: [QuestionModel]?) {
        if questionsList != nil {
            questions = questionsList!
            expiredQuestions = repository.loadExpiredQuestionsIdList()
        }
        if !(questions.count - expiredQuestions.items.count >= requaredQuestionsQuantity) {
            expiredQuestions.items = []
        }
        delegate?.onNewQuestionsGenerated()
    }
    
    private func checkQuestionIdIsExpired(_ questionId: String) -> Bool {
        if !expiredQuestions.items.isEmpty {
            for expiredId in expiredQuestions.items {
                if expiredId == questionId {
                    return true
                }
            }
        }
        return false
    }
}
