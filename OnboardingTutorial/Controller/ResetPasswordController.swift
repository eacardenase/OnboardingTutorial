//
//  ResetPasswordController.swift
//  OnboardingTutorial
//
//  Created by Edwin Cardenas on 8/1/25.
//

import UIKit

class ResetPasswordController: UIViewController {

    // MARK: - Properties

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .white
        button.addTarget(
            self,
            action: #selector(handleDismissal),
            for: .touchUpInside
        )

        return button
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(resource: .firebaseLogo)

        return imageView
    }()

    private let emailTextField: UITextField = {
        let textField = CustomTextField(placeholder: "Email")

        textField.keyboardType = .emailAddress

        return textField
    }()
    private let passwordTextField = CustomTextField(
        placeholder: "Password",
        isSecure: true
    )

    private lazy var resetPasswordButton: AuthButton = {
        let button = AuthButton(type: .system)

        button.setTitle("Send Reset Link", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.addTarget(
            self,
            action: #selector(handlePasswordReset),
            for: .touchUpInside
        )

        return button
    }()

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()

        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )

        view.addGestureRecognizer(tapGesture)
    }

}

// MARK: Helpers

extension ResetPasswordController {

    private func configureUI() {
        configureGradientBackground()
        
        let stackView = UIStackView(arrangedSubviews: [
            emailTextField,
            resetPasswordButton,
        ])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16

        view.addSubview(backButton)
        view.addSubview(iconImageView)
        view.addSubview(stackView)

        // backButton
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 16
            ),
            backButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
        ])

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

// MARK: - Actions

extension ResetPasswordController {

    @objc private func handleDismissal(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @objc private func handlePasswordReset(_ sender: UIButton) {
        print(#function)
    }

    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

}
