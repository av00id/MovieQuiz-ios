//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Сергей Андреев on 06.10.2022.
//

import UIKit


class AlertPresenter: AlertPresenterPotocol {
    
    weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate) {
        self.delegate = delegate
    }
    func show(alertModel: AlertModel) {
    let alert = UIAlertController(
        title: alertModel.title,
        message: alertModel.message,
        preferredStyle: .alert)
    
    let action = UIAlertAction(title: alertModel.buttonText,
                               style: .default,
                               handler: alertModel.completion)

    alert.addAction(action)
    alert.view.accessibilityIdentifier = "Game results"
    delegate?.presentAlert(alert)
    }
}
