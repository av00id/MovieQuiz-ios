//
//  MovieQuizPresenter .swift
//  MovieQuiz
//
//  Created by Сергей Андреев on 30.10.2022.
//

import Foundation
import UIKit

protocol MovieQuizVeiwControllerProtocol: AnyObject {
    
    func setButtonsEnabled(_ isEnabled: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    func highlightImageBorder(isAnswerRight: Bool)
    func showNetworkError(message: String)
}

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private weak var viewController: MovieQuizVeiwControllerProtocol?
    private var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticService!
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var correctAnswer: Int = 0
    
    
    init(viewController: MovieQuizVeiwControllerProtocol) {
        self.viewController = viewController
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    private func didAnswer(isCorrect: Bool) {
        if isCorrect {
            correctAnswer += 1
        }
    }
    
    func checkAnswer(userAnswer: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let isAnswerRight = currentQuestion.correctAnswer == userAnswer ? true : false
        proccedWithAnswer(isCorrect: isAnswerRight)
    }
    
    
    private func proccedWithAnswer(isCorrect: Bool) {
        didAnswer(isCorrect: isCorrect)
        
        viewController?.highlightImageBorder(isAnswerRight: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [ weak self] in
            guard let self = self else { return }
            
            
            self.proceedToNextQuestionOrResults()
            self.viewController?.setButtonsEnabled(true)
        }
    }
    
    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    private func proceedToNextQuestionOrResults() {
        
        if self.isLastQuestion() {
            
            let text = correctAnswer == self.questionsAmount ?
            "Поздравляем, вы ответили на 10 из 10!" :
            "Вы ответили на \(correctAnswer) из 10, попробуйте ещё раз!)" + "\n"
            
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            viewController?.show(quiz: viewModel)
            
            
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
        
    }
    
    func makeResultsMessage() -> String {
        statisticService?.store(correct: correctAnswer, total: questionsAmount)
        
        
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService?.gamesCount ?? 0)"
        let currentGameResultLine = "Ваш результат: \(correctAnswer) из \(questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(statisticService?.bestGame.gameStatistics() ?? "Данные отсутствуют")"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService?.totalAccuracy ?? 0.00))%"
        
        let resultMessage = [
            currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
        ].joined(separator: "\n")
        
        return resultMessage
    }
    
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswer = 0
        questionFactory?.loadData()
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
}



