import UIKit

final class MovieQuizViewController: UIViewController {
    
    //MARK: - Модель для описания Mock-данных
    
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    //MARK: - Модель для описания вопроса в квизе
    
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    //MARK: - Модель для описания результата квиза
    
    struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    //MARK: - Массив структур Mock-данных/10 вопросов для квиза
    private let questions: [QuizQuestion] = [
        
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    
    //MARK: - Переменная с индексом текущего вопроса
    
    private var currentQuestionIndex: Int = 0
    
    //MARK: - Переменная с количеством верных ответов
    
    private var correctAnswer: Int = 0
    
    //MARK: - Переменная изображения
    
    @IBOutlet private weak var imageView: UIImageView!
    
    //MARK: - Переменная текста вопроса
    
    @IBOutlet private weak var textLabel: UILabel!
    
    //MARK: - Переменная счетчика ответов
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    //MARK: - Переменная кнопки НЕТ
    
    @IBOutlet private weak var noButton: UIButton!
    
    //MARK: - Переменная кнопки ДА
    
    @IBOutlet private weak var yesButton: UIButton!
    
    //MARK: - Вызов функции для наполнения View данными
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        show(quiz: convert(model: questions[currentQuestionIndex]))
        
    }
    
    //MARK: - Функция преобразования Mock-данных
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    }
    
    //MARK: - Функция отображения Mock-данных
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    //MARK: - Функция нажатия на кнопку НЕТ
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        
        let isAnswerRight = !questions[currentQuestionIndex].correctAnswer
        showAnswerResult(isCorrect: isAnswerRight)
    }
    
    //MARK: - Функция нажатия на кнопку ДА
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        
        let isAnswerRight = questions[currentQuestionIndex].correctAnswer
        showAnswerResult(isCorrect: isAnswerRight)
    }
    
    //MARK: - Функция включения/отключения кнопок ДА и НЕТ
    
    private func setButtonsEnabled(_ isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    //MARK: - Функция отображения результата прохождения квиза
    
    private func show(quiz result: QuizResultsViewModel){
        
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText,
                                   style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswer = 0
            
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Функция показа корректности ответа
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswer += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        setButtonsEnabled(false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
            self.setButtonsEnabled(true)
        }
    }
    
    //MARK: - Функция перехода к следующему вопросу или к результатам квиза
    
    private func showNextQuestionOrResults() {
        
        if currentQuestionIndex == questions.count - 1 {
            
            let text = "Ваш результат: \(correctAnswer) из 10"
            
            let viewModel = QuizResultsViewModel(title: "Раунд окончен!",
                                                 text: text,
                                                 buttonText: "Сыграть еще раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            show(quiz: viewModel)
        }
    }
}



