//
//  LoginController.swift
//  OnboardingTutorial
//
//  Created by Edwin Cardenas on 8/1/25.
//

import UIKit

class LoginController: UIViewController {

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(resource: .firebaseLogo)

        return imageView
    }()

    private let emailTextField: UITextField = {
        let textField = UITextField()
        let spacer = UIView()

        spacer.widthAnchor.constraint(equalToConstant: 12).isActive = true

        textField.leftView = spacer
        textField.leftViewMode = .always
        textField.rightView = spacer
        textField.rightViewMode = .always

        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 8
        textField.borderStyle = .none
        textField.textColor = .white
        textField.keyboardAppearance = .dark
        textField.keyboardType = .asciiCapable
        textField.backgroundColor = UIColor(white: 1, alpha: 0.1)
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)]
        )

        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        let spacer = UIView()

        spacer.widthAnchor.constraint(equalToConstant: 12).isActive = true

        textField.leftView = spacer
        textField.leftViewMode = .always
        textField.rightView = spacer
        textField.rightViewMode = .always

        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 8
        textField.borderStyle = .none
        textField.textColor = .white
        textField.keyboardAppearance = .dark
        textField.keyboardType = .asciiCapable
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor(white: 1, alpha: 0.1)
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [
                .foregroundColor: UIColor.white.withAlphaComponent(0.7)
            ]
        )

        return textField
    }()

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

}

// MARK: - Helpers

extension LoginController {

    private func configureUI() {
        navigationController?.navigationBar.barStyle = .black

        let gradient = CAGradientLayer()

        gradient.frame = view.frame
        gradient.locations = [0, 1]
        gradient.colors = [
            UIColor.systemPurple.cgColor, UIColor.systemCyan.cgColor,
        ]

        view.layer.addSublayer(gradient)

        let stackView = UIStackView(arrangedSubviews: [
            emailTextField, passwordTextField,
        ])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16

        view.addSubview(iconImageView)
        view.addSubview(stackView)

        // iconImageView
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 120),
            iconImageView.widthAnchor.constraint(
                equalTo: iconImageView.heightAnchor
            ),
            iconImageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 32
            ),
        ])

        // stackView
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: iconImageView.bottomAnchor,
                constant: 32
            ),
            stackView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 32
            ),
            stackView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -32
            ),
        ])
    }

}
