import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizVeiwControllerProtocol {
    
    private var presenter: MovieQuizPresenter!
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
        
        presenter = MovieQuizPresenter(viewController: self)
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
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()
        
        let alert = UIAlertController(
            title: result.title,
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.presenter.restartGame()
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func highlightImageBorder(isAnswerRight: Bool) {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isAnswerRight ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        setButtonsEnabled(false)
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
}
extension MovieQuizViewController: AlertPresenterDelegate {
    func presentAlert(_ alert: UIAlertController) {
        present(alert, animated: true)
    }
}




