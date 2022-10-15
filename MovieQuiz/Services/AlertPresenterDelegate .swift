//
//  AlertPresenterDelegate .swift
//  MovieQuiz
//
//  Created by Сергей Андреев on 06.10.2022.
//

import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func presentAlert(_ alert:UIAlertController)
}
