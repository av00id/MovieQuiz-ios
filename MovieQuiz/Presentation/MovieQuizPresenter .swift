//
//  MovieQuizPresenter .swift
//  MovieQuiz
//
//  Created by Сергей Андреев on 30.10.2022.
//

import Foundation
import UIKit

final class MovieQiuzPresenter: QuestionFactoryDelegate {
    
    private weak var viewController: MovieQuizViewController?
    private var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticService!
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var correctAnswer: Int = 0
    
    init(viewController: MovieQuizViewController) {
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
            self.viewController?.removeHighlight()
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
        
        if isLastQuestion() {
            statisticService?.store(correct: correctAnswer, total: questionsAmount)
            
            let alertModel = AlertModel(
                title: "Раунд окончен!",
                message: "Ваш результат: \(correctAnswer) из \(self.questionsAmount)\n" +
                "Количество сыгранных квизов: \(statisticService?.gamesCount ?? 0)\n" +
                "Рекорд: \(statisticService?.bestGame.gameStatistics() ?? "Данные отсутствуют")\n" +
                "Средняя точность: " + String(format: "%.2f", statisticService?.totalAccuracy ?? 0.00) + "%",
                buttonText: "Сыграть еще раз",
                completion: {[weak self] _ in
                    guard let self = self else { return }
                    
                    self.restartGame()
                
                })
            viewController?.alertPresenter?.show(alertModel:alertModel)
            
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
        
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



