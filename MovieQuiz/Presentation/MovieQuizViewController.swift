import UIKit

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate {
    
    private var presenter: MovieQiuzPresenter!
    var alertPresenter: AlertPresenterPotocol!
    
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var noButton: UIButton!
    
    @IBOutlet private weak var yesButton: UIButton!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        
        presenter = MovieQiuzPresenter(viewController: self)
        alertPresenter = AlertPresenter(delegate: self)
        
    }
 
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        
        presenter.checkAnswer(userAnswer: false)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        
        presenter.checkAnswer(userAnswer: true)
    }
    
    func setButtonsEnabled(_ isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }

    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }

    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
  
    
    func highlightImageBorder(isAnswerRight: Bool) {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isAnswerRight ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        setButtonsEnabled(false)
    }
    
    func removeHighlight() {
        self.imageView.layer.borderWidth = 0
    }

    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] _ in
            guard let self = self else { return }
            self.presenter.restartGame()
        }
        alertPresenter?.show(alertModel: model)
    }

    
    func presentAlert(_ alert: UIAlertController) {
        present(alert, animated: true)
    }
}


   
  
