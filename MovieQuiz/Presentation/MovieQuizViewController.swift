import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
   
    //MARK: - Properties
    private let questionFactory: QuestionsFactoryProtocol = QuestionsFactoryImpl(
        networkLoader: NetworkLoaderImp(
            networkClient: NetworkClient()
        ),
        repository: StatisticDataRepositoryImplUserDefaults()
    )
    private let statisticService: StatisticServiceProtocol = StatisticServiceImpl(
        dataRepository: StatisticDataRepositoryImplUserDefaults()
    )
    private var questionCounter = 1
    private let totalQuizQuestionsCount = 10
    private var correctResponcesCounter = 0
    private var correctResponse: Response = .yes
  
    @IBOutlet weak private var questionIndexView: UILabel!
    @IBOutlet weak private var questionView: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var buttonYesView: UIButton!
    @IBOutlet weak private var buttonNoView: UIButton!
    @IBOutlet weak private var loadIndicatorView: UIActivityIndicatorView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory.addDelegate(delegate: self)
        restartQuiz()
    }
  
    //MARK: - QuestionsFactoryDelegate
    func onNewQuestionsGenerated() {
        DispatchQueue.main.async { [weak self] in
            self?.updateLoadingState(isLoading: false)
            self?.updateQuizQuestion()
        }
    }
    
    func onNetworkFailure(errorDescription: String) {
        let alertModel = ScreenModelsCreator.createNetworkFailureAlertScreenModel(
            errorDescription: errorDescription,
            completion: { [weak self] _ in
                guard let self = self else {return}
                self.questionFactory.generateNewQuestions(requiredQuantity: totalQuizQuestionsCount)
            }
        )
        AlertPresenter.showAlert(model: alertModel, delegate: self)
    }
    
    //MARK: - AlertPresenterDelegate
    func presentAlert(_ alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Private functions
    private func updateLoadingState(isLoading: Bool) {
        enableButtons(!isLoading)
        loadIndicatorView.isHidden = !isLoading
    }
    
    private func updateQuizQuestion() {
        guard let question = questionFactory.getNextQuestion() else {
            finishQuiz()
            return
        }
        let questionMovieRank = Int.random(in: 5..<10)
        
        correctResponse = getCorrectResponse(
            trueMovieRank: question.movieRank,
            questionMovieRank: questionMovieRank
        )
        let questionScreenModel = ScreenModelsCreator.createQuestionScreenModel(
            counter: questionCounter,
            questionAmount: totalQuizQuestionsCount,
            questionMovieRank: questionMovieRank,
            questionImage: question.image
        )
        showQuestion(questionScreenModel)
    }
    
    private func getCorrectResponse(trueMovieRank: Float, questionMovieRank: Int) -> Response {
        if trueMovieRank > Float(questionMovieRank) {
            return .yes
        }
        return .no
    }
    
    private func showQuestion(_ model: QuestionScreenModel) {
        showImageBorder(ImageBorderState.noBorders)
        questionIndexView.text = model.counter
        imageView.image = model.image
        questionView.text = model.question
    }
    
    private func showImageBorder(_ state: ImageBorderState) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = state.values.width
        imageView.layer.borderColor = state.values.colour
    }
    
    private func handleUserResponse(_ userResponse: Response) {
        enableButtons(false)
        var borderState = ImageBorderState.incorrectUserResponse
        
        if userResponse == correctResponse {
            borderState = ImageBorderState.correctUserResponse
            correctResponcesCounter += 1
        }
        showImageBorder(borderState)
        questionCounter += 1
  
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {
                return
            }
            self.updateQuizQuestion()
            self.enableButtons(true)
        }
    }
    
    private func finishQuiz() {
        let statisticModel = statisticService.getStatistic(
            currentGameCorrects: correctResponcesCounter,
            currentGameQuestionAmount: totalQuizQuestionsCount
        )
        let alertModel = ScreenModelsCreator.createQuizFinishedAlertScreenModel(
            correctResponcesCount: correctResponcesCounter,
            questionsCount: totalQuizQuestionsCount,
            statistic: statisticModel,
            completion: { [weak self] _ in
                guard let self = self else {return}
                self.restartQuiz()
            }
        )
        AlertPresenter.showAlert(model: alertModel, delegate: self)
    }
    
    private func restartQuiz() {
        questionCounter = 1
        correctResponcesCounter = 0
        updateLoadingState(isLoading: true)
        questionFactory.generateNewQuestions(requiredQuantity: totalQuizQuestionsCount)
    }
    
    private func enableButtons(_ isEnabled: Bool) {
        buttonYesView.isEnabled = isEnabled
        buttonNoView.isEnabled = isEnabled
    }
    
    //MARK: - Actions
    @IBAction private func onNoButtonClick() {
        handleUserResponse(.no)
    }
    @IBAction private func onYesButtonClick() {
        handleUserResponse(.yes)
    }
}
