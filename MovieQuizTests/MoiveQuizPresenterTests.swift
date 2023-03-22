//
//  MoiveQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Сергей Андреев on 02.11.2022.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizControllerProtocolMock: MovieQuizVeiwControllerProtocol {
    
    func setButtonsEnabled(_ isEnabled: Bool) {}
    
    func showLoadingIndicator() {}
    
    func hideLoadingIndicator() {}
    
    func show(quiz step: MovieQuiz.QuizStepViewModel) {}
    
    func show(quiz result: MovieQuiz.QuizResultsViewModel) {}
    
    func highlightImageBorder(isAnswerRight: Bool) {}
  
    func showNetworkError(message: String) {}
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertMode() throws {
        let viewControllerMock = MovieQuizControllerProtocolMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}

