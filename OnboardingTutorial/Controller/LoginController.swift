//
//  LoginController.swift
//  OnboardingTutorial
//
//  Created by Edwin Cardenas on 8/1/25.
//

import UIKit

class LoginController: UIViewController {

    // MARK: - Properties

    private var viewModel = LoginViewModel()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(resource: .firebaseLogo)

        return imageView
    }()

    private lazy var emailTextField: UITextField = {
        let textField = CustomTextField(placeholder: "Email")

        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.addTarget(
            self,
            action: #selector(textFieldEditingChanged),
            for: .editingChanged
        )

        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = CustomTextField(
            placeholder: "Password",
            isSecure: true
        )

        textField.addTarget(
            self,
            action: #selector(textFieldEditingChanged),
            for: .editingChanged
        )

        return textField
    }()

    private lazy var loginButton: AuthButton = {
        let button = AuthButton(type: .system)

        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.addTarget(
            self,
            action: #selector(handleLogin),
            for: .touchUpInside
        )

        return button
    }()

    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()

        let attributedTitle = NSMutableAttributedString(
            string: "Forgot your password? ",
            attributes: [
                .foregroundColor: UIColor.white.withAlphaComponent(0.87),
                .font: UIFont.boldSystemFont(ofSize: 15),
            ]
        )

        attributedTitle.append(
            NSAttributedString(
                string: "Get help signing in.",
                attributes: [
                    .foregroundColor: UIColor.white,
                    .font: UIFont.boldSystemFont(ofSize: 15),
                ]
            )
        )

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(
            self,
            action: #selector(showPasswordResetController),
            for: .touchUpInside
        )

        return button
    }()

    private let dividerView = DividerView()

    private lazy var googleLoginButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(
            UIImage(resource: .btnGoogleLightPressedIos).withRenderingMode(
                .alwaysOriginal
            ),
            for: .normal
        )
        button.setTitle("  Log in with Google", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(
            self,
            action: #selector(handleGoogleLogin),
            for: .touchUpInside
        )

        return button
    }()

    private lazy var dontHaveAccountButton: UIButton = {
        let button = UIButton()

        let attributedTitle = NSMutableAttributedString(
            string: "Don't have an account? ",
            attributes: [
                .foregroundColor: UIColor.white.withAlphaComponent(0.87),
                .font: UIFont.boldSystemFont(ofSize: 16),
            ]
        )

        attributedTitle.append(
            NSAttributedString(
                string: "Sign Up",
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
            action: #selector(showSignUpController),
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

// MARK: - Helpers

extension LoginController {

    private func configureUI() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true

        configureGradientBackground()

        let stackView = UIStackView(arrangedSubviews: [
            emailTextField,
            passwordTextField,
            loginButton,
        ])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16

        let secondStack = UIStackView(arrangedSubviews: [
            forgotPasswordButton,
            dividerView,
            googleLoginButton,
        ])

        secondStack.translatesAutoresizingMaskIntoConstraints = false
        secondStack.axis = .vertical
        secondStack.spacing = 28

        view.addSubview(iconImageView)
        view.addSubview(stackView)
        view.addSubview(secondStack)
        view.addSubview(dontHaveAccountButton)

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

        // secondStack
        NSLayoutConstraint.activate([
            secondStack.topAnchor.constraint(
                equalTo: stackView.bottomAnchor,
                constant: 24
            ),
            secondStack.leadingAnchor.constraint(
                equalTo: stackView.leadingAnchor
            ),
            secondStack.trailingAnchor.constraint(
                equalTo: stackView.trailingAnchor
            ),
        ])

        // signUpButton
        NSLayoutConstraint.activate([
            dontHaveAccountButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            ),
            dontHaveAccountButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
        ])
    }

}

// MARK: - Actions

extension LoginController {

    @objc private func handleLogin(_ sender: UIButton) {
        print(#function)
    }

    @objc private func showPasswordResetController(_ sender: UIButton) {
        let resetPasswordController = ResetPasswordController()

        navigationController?.pushViewController(
            resetPasswordController,
            animated: true
        )
    }

    @objc private func handleGoogleLogin(_ sender: UIButton) {
        print(#function)
    }

    @objc private func showSignUpController(_ sender: UIButton) {
        let controller = RegistrationController()

        navigationController?.pushViewController(
            controller,
            animated: true
        )
    }

    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @objc private func textFieldEditingChanged(_ sender: UITextField) {
        if sender === emailTextField {
            viewModel.email = sender.text
        } else if sender === passwordTextField {
            viewModel.password = sender.text
        }
        
        print("DEBUG: Form is valid \(viewModel.formIsValid)")
    }

}
