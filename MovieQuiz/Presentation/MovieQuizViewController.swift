import UIKit

final class MovieQuizViewController: UIViewController {
    
    private var questionCounter = 1
    private var correctQuestionsCounter = 0
    private var currentQuestionIndex = 0
    private var questions = [quizQuestion]()
    private var alreadyUsedQuestions = [Int]()
    private var questionMovieRank = 0
    
    @IBOutlet weak private var questionIndexView: UILabel!
    @IBOutlet weak private var questionView: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    
    private func generateQuestionList() -> [quizQuestion] {
        let questionsList: [quizQuestion] = [
            quizQuestion (imageTitle: "The Godfather", movieRank: 9.2),
            quizQuestion (imageTitle: "The Dark Knight", movieRank: 9.0),
            quizQuestion (imageTitle: "Kill Bill", movieRank: 8.1),
            quizQuestion (imageTitle: "The Avengers", movieRank: 8.0),
            quizQuestion (imageTitle: "Deadpool", movieRank: 8.0),
            quizQuestion (imageTitle: "The Green Knight", movieRank: 6.6),
            quizQuestion (imageTitle: "Old", movieRank: 5.8),
            quizQuestion (imageTitle: "The Ice Age Adventures of Buck Wild", movieRank: 4.3),
            quizQuestion (imageTitle: "Tesla", movieRank: 5.1),
            quizQuestion (imageTitle: "Vivarium", movieRank: 5.8),
        ]
        return questionsList
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
        
        let questionViewModel = questionViewModel(
            counter: questionCounter,
            questionCount: questions.count,
            image: UIImage(named: questions[currentQuestionIndex].imageTitle) ?? UIImage(),
            movieRank: questionMovieRank
        )
        showQuestion(questionViewModel)
    }
    
    private func showQuestion(_ model: questionViewModel) {
        showImageBorder(imageBorderState.noBorders)
        questionIndexView.text = String(model.counter) + "/" + String(model.questionCount)
        imageView.image = model.image
        questionView.text = "Рейтинг этого фильма больше чем " + String(model.movieRank) + "?"
    }
    
    private func showImageBorder(_ state: imageBorderState) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = state.values.width
        imageView.layer.borderColor = state.values.colour
    }
    
    private func handleUserResponse(_ userResponse: response) {
        var correctResponse: response = .no
        if questions[currentQuestionIndex].movieRank > Float(questionMovieRank) {
            correctResponse = .yes
        }
        
        var borderState = imageBorderState.incorrectUserResponse
        if userResponse == correctResponse {
            borderState = imageBorderState.correctUserResponse
            correctQuestionsCounter += 1
        }
        
        showImageBorder(borderState)
        questionCounter += 1
        alreadyUsedQuestions.append(currentQuestionIndex)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.updateQuizQuestion()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questions = generateQuestionList()
        restartQuiz()
    }
    
    @IBAction private func onNoButtonClick() {
        handleUserResponse(.no)
    }
    @IBAction private func onYesButtonClick() {
        handleUserResponse(.yes)
    }
}

struct quizQuestion {
    let imageTitle: String
    let movieRank: Float
}

struct questionViewModel {
    let counter: Int
    let questionCount: Int
    let image: UIImage
    let movieRank: Int
}

enum response {
    case yes, no
}

enum imageBorderState {
    case noBorders
    case correctUserResponse
    case incorrectUserResponse
    
    var values: (width: CGFloat, colour: CGColor) {
        switch self {
        case .noBorders: return (0,UIColor.ypBackground.cgColor)
        case .correctUserResponse: return (8, UIColor.ypGreen.cgColor)
        case .incorrectUserResponse: return (8, UIColor.ypRed.cgColor)
        }
    }
}
