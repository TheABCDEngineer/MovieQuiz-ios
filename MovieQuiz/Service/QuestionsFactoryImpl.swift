import Foundation

class QuestionsFactoryImpl: QuestionsFactoryProtocol {
    private let networkLoader: NetworkLoaderProtocol
    private let repository: StatisticDataRepository
    private var movies = [MovieModel]()
    private var requaredQuestionsQuantity = 0
    private var questionsCounter = 0
    private var expiredMovies = ExpiredMoviesId(items: [])
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
    
    func prepareFactory() {
        networkLoader.getMoviesList(
            onSuccess: { [weak self] questionsList in
                guard let self = self else { return }
                self.movies = questionsList
                self.expiredMovies = self.repository.loadExpiredMoviesIdList()
                self.delegate?.onPreparedFactory()
            },
            onFailure: { [weak self] error in
                self?.delegate?.onNetworkFailure(errorDescription: error)
            }
        )
    }
    
    func prepareNewQuestionsQueue(questionsQuantity: Int) {
        requaredQuestionsQuantity = questionsQuantity
        questionsCounter = 0
        if !(movies.count - expiredMovies.items.count >= requaredQuestionsQuantity) {
            expiredMovies.items = []
        }
        getNextQuestion()
        
    }
    
    func getNextQuestion() {
        if (questionsCounter == requaredQuestionsQuantity)  {
            repository.saveExpiredMoviesIdList(expiredMovies)
            delegate?.onNewQuestionGenerated(model: nil)
            return
        }
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            var randomIndex = 0
            repeat {
                randomIndex = Int.random(in: 0..<movies.count)
            } while checkMovieIdIsExpired(
                movies[randomIndex].id
            )
            
            expiredMovies.items.append(
                movies[randomIndex].id
            )
            let question = convertMovieToQuizQuestionModel(movies[randomIndex])
            questionsCounter += 1
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.onNewQuestionGenerated(model: question)
            }
        }
    }
 
    private func checkMovieIdIsExpired(_ questionId: String) -> Bool {
        if !expiredMovies.items.isEmpty {
            for expiredId in expiredMovies.items {
                if expiredId == questionId {
                    return true
                }
            }
        }
        return false
    }
    
    private func convertMovieToQuizQuestionModel (_ model: MovieModel) -> QuizQuestionModel {
        return QuizQuestionModel(
            image: createImageDataFromUrl(model.imageUrl),
            movieRank: model.movieRank
        )
    }
    
    private func createImageDataFromUrl(_ url: URL?) -> Data {
        if url == nil {
            return Data()
        }
        var imageData = Data()
        do {
            imageData = try Data(contentsOf: url!)
        } catch {}
        
        return imageData
    }
}
