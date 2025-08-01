//
//  LoginController.swift
//  OnboardingTutorial
//
//  Created by Edwin Cardenas on 8/1/25.
//

import UIKit

class LoginController: UIViewController {

    // MARK: - Properties

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(resource: .firebaseLogo)

        return imageView
    }()

    private let emailTextField = CustomTextField(placeholder: "Email")

    private let passwordTextField = CustomTextField(
        placeholder: "Password",
        isSecure: true
    )

    private lazy var loginButton: AuthButton = {
        let button = AuthButton()

        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.addTarget(
            self,
            action: #selector(handleLogin),
            for: .touchUpInside
        )

        return button
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
            emailTextField, passwordTextField, loginButton,
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

// MARK: - Actions

extension LoginController {

    @objc private func handleLogin(_ sender: UIButton) {
        print(#function)
    }

}
