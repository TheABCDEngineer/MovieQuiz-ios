import UIKit

class AlertPresenter {
    static func showAlert(
        model: AlertScreenModel,
        delegate: AlertPresenterDelegate
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
        delegate.presentAlert(alert)
    }
}
