import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol, AlertPresenterDelegate {
    //MARK: - Properties
    private var presenter: MovieQuizPresenterProtocol?
  
    @IBOutlet weak private var questionIndexView: UILabel!
    @IBOutlet weak private var questionView: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var buttonYesView: UIButton!
    @IBOutlet weak private var buttonNoView: UIButton!
    @IBOutlet weak private var loadIndicatorView: UIActivityIndicatorView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let repository = StatisticDataRepositoryImplUserDefaults()
        let networkLoader = NetworkLoaderImp(
            networkClient: NetworkClient()
        )
        let statisticService = StatisticServiceImpl(dataRepository: repository)
        let questionFactory = QuestionsFactoryImpl(
            networkLoader: networkLoader,
            repository: repository
        )
        let valueCreator = ValueCreatorImplRandom()
        
        presenter = MovieQuizPresenter(
            viewController: self,
            questionFactory: questionFactory,
            statisticService: statisticService,
            valueCreator: valueCreator
        )
        updateLoadingState(isLoading: true)
    }
 
    //MARK: - AlertPresenterDelegate
    func presentAlert(_ alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - MovieQuizViewControllerProtocol
    func updateLoadingState(isLoading: Bool) {
        enableButtons(!isLoading)
        loadIndicatorView.isHidden = !isLoading
    }
    
    func showAlert(model: AlertScreenModel) {
        AlertPresenter.showAlert(model: model, delegate: self)
    }
 
    func showQuestion(model: QuestionScreenModel) {
        showImageBorder(ImageBorderState.noBorders)
        questionIndexView.text = model.counter
        imageView.image = model.image
        questionView.text = model.question
    }
    
    func showUserResponseResult(isCorrect: Bool) {
        var borderState = ImageBorderState.incorrectUserResponse
        if isCorrect {
            borderState = ImageBorderState.correctUserResponse
        }
        showImageBorder(borderState)
    }
    
    //MARK: - Private functions
    private func showImageBorder(_ state: ImageBorderState) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = state.values.width
        imageView.layer.borderColor = state.values.colour
    }
    
    private func enableButtons(_ isEnabled: Bool) {
        buttonYesView.isEnabled = isEnabled
        buttonNoView.isEnabled = isEnabled
    }
    
    //MARK: - Actions
    @IBAction private func onNoButtonClick() {
        enableButtons(false)
        presenter?.onButtonClick(userResponse: .no)
    }
    @IBAction private func onYesButtonClick() {
        enableButtons(false)
        presenter?.onButtonClick(userResponse: .yes)
    }
}
