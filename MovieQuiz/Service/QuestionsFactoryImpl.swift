import Foundation

class QuestionsFactoryImpl: QuestionsFactoryProtocol {
    private let questionsGenerator: QuestionsGeneratorProtocol
    private var questions = [QuestionModel]()
    private var alreadyUsedQuestions = [Int]()
    private weak var delegate: QuestionFactoryDelegate?
    
    init(questionsGenerator: QuestionsGeneratorProtocol) {
        self.questionsGenerator = questionsGenerator
    }
    
    private func checkQuestionIsAlreadyUsed(_ questionIndex: Int) -> Bool {
        for index in alreadyUsedQuestions {
            if index == questionIndex {
                return true
            }
        }
        return false
    }
    
    private func getNextQuestionIndex(_ questionCount: Int) -> Int {
        var randomIndex = 0
        repeat {
            randomIndex = Int.random(in: 0..<questionCount)
        } while
        checkQuestionIsAlreadyUsed(randomIndex)
        
        return randomIndex
    }
    
    func addDelegate(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    func generateNewQuestions() {
        questions = questionsGenerator.getQuestionsList()
        alreadyUsedQuestions = []
        delegate?.onNewQuestionsGenerated()
    }
    
    func getNextQuestion() -> QuestionModel? {
        if (alreadyUsedQuestions.count == questions.count)  {
            return nil
        }
        let questionIndex = getNextQuestionIndex(questions.count)
        alreadyUsedQuestions.append(questionIndex)
        return questions[questionIndex]
    }
    
    func getQuestionsCount() -> Int {
        return questions.count
    }
}
