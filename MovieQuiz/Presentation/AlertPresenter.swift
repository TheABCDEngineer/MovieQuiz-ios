import UIKit

class AlertPresenter {
    static func showAlert(
        model: AlertScreenModel,
        controller: UIViewController
    ) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default,
            handler: model.completion
        )
        alert.addAction(action)
        controller.present(alert, animated: true, completion: nil)
    }
}
