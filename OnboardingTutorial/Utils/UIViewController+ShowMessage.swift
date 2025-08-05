//
//  UIViewController+ShowMessage.swift
//  OnboardingTutorial
//
//  Created by Edwin Cardenas on 8/5/25.
//

import UIKit

extension UIViewController {

    func showMessage(withTitle title: String, message: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        alertController.addAction(UIAlertAction(title: "OK", style: .default))

        present(alertController, animated: true)
    }

}
