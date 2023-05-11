import UIKit

final class MovieQuizViewController: UIViewController {
    
    private let questionsGenerator = QuizQuestionsGenerator()
    private var questionCounter = 1
    private var correctQuestionsCounter = 0
    private var currentQuestionIndex = 0
    private var questions = [QuizQuestionDto]()
    private var alreadyUsedQuestions = [Int]()
    private var questionMovieRank = 0
    
    @IBOutlet weak private var questionIndexView: UILabel!
    @IBOutlet weak private var questionView: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var buttonYesView: UIButton!
    @IBOutlet weak private var buttonNoView: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questions = questionsGenerator.generateQuestionList()
        restartQuiz()
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
    
    private func updateQuizQuestion() {
        if (questionCounter == questions.count + 1)  {
            finishQuiz()
            return
        }
        currentQuestionIndex = getNextQuestionIndex(questions.count)
        questionMovieRank = Int.random(in: 5..<10)
        
        let questionViewModel = QuestionViewModel(
            counter: questionCounter,
            questionCount: questions.count,
            image: UIImage(named: questions[currentQuestionIndex].imageTitle) ?? UIImage(),
            movieRank: questionMovieRank
        )
        showQuestion(questionViewModel)
    }
    
    private func showQuestion(_ model: QuestionViewModel) {
        showImageBorder(ImageBorderState.noBorders)
        questionIndexView.text = String(model.counter) + "/" + String(model.questionCount)
        imageView.image = model.image
        questionView.text = "Рейтинг этого фильма больше чем " + String(model.movieRank) + "?"
    }
    
    private func showImageBorder(_ state: ImageBorderState) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = state.values.width
        imageView.layer.borderColor = state.values.colour
    }
    
    private func handleUserResponse(_ userResponse: Response) {
        var correctResponse: Response = .no
        if questions[currentQuestionIndex].movieRank > Float(questionMovieRank) {
            correctResponse = .yes
        }
        
        var borderState = ImageBorderState.incorrectUserResponse
        if userResponse == correctResponse {
            borderState = ImageBorderState.correctUserResponse
            correctQuestionsCounter += 1
        }
        
        showImageBorder(borderState)
        questionCounter += 1
        alreadyUsedQuestions.append(currentQuestionIndex)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.updateQuizQuestion()
            self.enableButtons(true)
        }
    }
    
    private func finishQuiz() {
        let message = "Ваш результат " + String(correctQuestionsCounter) + "/" + String(questions.count)
        let alert = UIAlertController(
            title: "Этот радунд окончен!",
            message: message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "Сыграть ещё раз", style: .default) { _ in
            self.restartQuiz()
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func restartQuiz() {
        questionCounter = 1
        correctQuestionsCounter = 0
        alreadyUsedQuestions = []
        updateQuizQuestion()
    }
    
    private func enableButtons(_ isEnabled: Bool) {
        buttonYesView.isEnabled = isEnabled
        buttonNoView.isEnabled = isEnabled
    }
    
    @IBAction private func onNoButtonClick() {
        enableButtons(false)
        handleUserResponse(.no)
    }
    @IBAction private func onYesButtonClick() {
        enableButtons(false)
        handleUserResponse(.yes)
    }
}
