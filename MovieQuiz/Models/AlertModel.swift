//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Сергей Андреев on 06.10.2022.
//
import Foundation
import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion: (UIAlertAction) -> Void
}
