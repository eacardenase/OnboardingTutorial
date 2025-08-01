//
//  RegistrationController.swift
//  OnboardingTutorial
//
//  Created by Edwin Cardenas on 8/1/25.
//

import UIKit

class RegistrationController: UIViewController {

    // MARK: - Properties

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(resource: .firebaseLogo)

        return imageView
    }()

    private let fullNametField = CustomTextField(placeholder: "Fullname")
    private let emailTextField = CustomTextField(placeholder: "Email")

    private let passwordTextField = CustomTextField(
        placeholder: "Password",
        isSecure: true
    )

    private lazy var signUpButton: AuthButton = {
        let button = AuthButton(type: .system)

        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.addTarget(
            self,
            action: #selector(handleSignUp),
            for: .touchUpInside
        )

        return button
    }()

    private lazy var alreadyHaveAccountButton: UIButton = {
        let button = UIButton()

        let attributedTitle = NSMutableAttributedString(
            string: "Already have an account? ",
            attributes: [
                .foregroundColor: UIColor.white.withAlphaComponent(0.87),
                .font: UIFont.boldSystemFont(ofSize: 16),
            ]
        )

        attributedTitle.append(
            NSAttributedString(
                string: "Log In",
                attributes: [
                    .foregroundColor: UIColor.white,
                    .font: UIFont.boldSystemFont(ofSize: 16),
                ]
            )
        )

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(
            self,
            action: #selector(showLoginController),
            for: .touchUpInside
        )

        return button
    }()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

}

// MARK: - Helpers

extension RegistrationController {

    private func configureUI() {
        let gradient = CAGradientLayer()

        gradient.frame = view.frame
        gradient.locations = [0, 1]
        gradient.colors = [
            UIColor.systemPurple.cgColor, UIColor.systemTeal.cgColor,
        ]

        view.layer.addSublayer(gradient)

        let stackView = UIStackView(arrangedSubviews: [
            fullNametField,
            emailTextField,
            passwordTextField,
            signUpButton,
        ])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16

        view.addSubview(iconImageView)
        view.addSubview(stackView)
        view.addSubview(alreadyHaveAccountButton)

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

        // loginButton
        NSLayoutConstraint.activate([
            alreadyHaveAccountButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            ),
            alreadyHaveAccountButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
        ])
    }

}

// MARK: - Actions

extension RegistrationController {

    @objc private func handleSignUp(_ sender: UIButton) {
        print(#function)
    }

    @objc private func showLoginController(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

}
