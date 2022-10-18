//
//  QuestionFactoryDelegate .swift
//  MovieQuiz
//
//  Created by Сергей Андреев on 06.10.2022.
//

import UIKit

protocol QuestionFactoryDelegate: AnyObject {
    
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
