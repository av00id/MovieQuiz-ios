import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    //MARK: - Переменные и аутлеты
    private let questionsAmount: Int = 10
    
    private var questionFactory: QuestionFactoryProtocol?
    
    private var currentQuestion: QuizQuestion?
    
    private var alertPresenter: AlertPresenterPotocol?
    
    private var statisticService: StatisticService?
    
    private var currentQuestionIndex: Int = 0
    
    private var correctAnswer: Int = 0
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var noButton: UIButton!
    
    @IBOutlet private weak var yesButton: UIButton!
    
    //MARK: - Вызов функций во View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        
        questionFactory = QuestionFactory(delegate: self)
        alertPresenter = AlertPresenter(delegate: self)
        statisticService = StatisticServiceImplementation()
        questionFactory?.requestNextQuestion()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Управление кнопками
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        
        checkAnswer(userAnswer: false)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        
        checkAnswer(userAnswer: true)
    }
    
    private func setButtonsEnabled(_ isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    //MARK: - Функции
 
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
 
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func checkAnswer(userAnswer: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let isAnswerRight = currentQuestion.correctAnswer == userAnswer ? true : false
        showAnswerResult(isCorrect: isAnswerRight)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswer += 1
        }
        
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        setButtonsEnabled(false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [ weak self] in
            guard let self = self else { return }
            
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
            self.setButtonsEnabled(true)
        }
    }
    
    private func showNextQuestionOrResults() {
        
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService?.store(correct: correctAnswer, total: questionsAmount)
            
            let alertModel = AlertModel(
                title: "Раунд окончен!",
                message: "Ваш результат: \(correctAnswer) из \(questionsAmount)\n" +
                "Количество сыгранных квизов: \(statisticService?.gamesCount ?? 0)\n" +
                "Рекорд: \(statisticService?.bestGame.gameStatistics() ?? "Данные отсутствуют")\n" +
                "Средняя точность: " + String(format: "%.2f", statisticService?.totalAccuracy ?? 0.00) + "%",
                buttonText: "Сыграть еще раз",
                completion: {[weak self] _ in
                    guard let self = self else { return }
                    
                    self.currentQuestionIndex = 0
                    self.correctAnswer = 0
                    
                    self.questionFactory?.requestNextQuestion()
                })
            alertPresenter?.show(alertModel:alertModel)
            
        } else {
            currentQuestionIndex += 1
            
            questionFactory?.requestNextQuestion()
        }
    }
    // MARK: - Делегаты
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func presentAlert(_ alert: UIAlertController) {
        present(alert, animated: true)
    }
    
}

///К сожалению, совсем не дружу с терминалом, создать файл гитигнор по инструкции удалось, а что делать с ним дальше - непонятно(
