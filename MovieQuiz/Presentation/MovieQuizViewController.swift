import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    //MARK: - Properties
    private let questionFactory: QuestionsFactoryProtocol = QuestionsFactoryImpl(
        questionsGenerator: QuestionsGeneratorImpl()
    )
    private let statisticService: StatisticServiceProtocol = StatisticServiceImpl(
        dataRepository: StatisticDataRepositoryImplUserDefaults()
    )
    private var questionCounter = 1
    private var correctResponcesCounter = 0
    private var correctResponse: Response = .yes
  
    @IBOutlet weak private var questionIndexView: UILabel!
    @IBOutlet weak private var questionView: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var buttonYesView: UIButton!
    @IBOutlet weak private var buttonNoView: UIButton!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory.addDelegate(delegate: self)
        restartQuiz()
    }
  
    //MARK: - QuestionsFactoryDelegate
    func onNewQuestionsGenerated() {
        DispatchQueue.main.async { [weak self] in
            self?.updateQuizQuestion()
        }
    }
    
    //MARK: - Private functions
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
            questionCount: questionFactory.getQuestionsCount(),
            questionMovieRank: questionMovieRank,
            questionImageUrl: question.imageUrl
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
            currentGameQuestionAmount: questionFactory.getQuestionsCount()
        )
        let alertModel = ScreenModelsCreator.createAlertScreenModel(
            correctResponcesCount: correctResponcesCounter,
            questionsCount: questionFactory.getQuestionsCount(),
            statistic: statisticModel,
            completion: { [weak self] _ in
                guard let self = self else {return}
                self.restartQuiz()
            }
        )
        AlertPresenter.showAlert(model: alertModel, controller: self)
    }
    
    private func restartQuiz() {
        questionCounter = 1
        correctResponcesCounter = 0
        questionFactory.generateNewQuestions()
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
