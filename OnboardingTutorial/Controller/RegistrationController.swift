//
//  RegistrationController.swift
//  OnboardingTutorial
//
//  Created by Edwin Cardenas on 8/1/25.
//

import UIKit

class RegistrationController: UIViewController {

    // MARK: - Properties

    private var viewModel = RegistrationViewModel()
    weak var delegate: AuthenticationDelegate?

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(resource: .firebaseLogo)

        return imageView
    }()
    private lazy var fullNametField: UITextField = {
        let textField = CustomTextField(placeholder: "Fullname")

        textField.autocapitalizationType = .words
        textField.addTarget(
            self,
            action: #selector(textFieldEditingChanged),
            for: .editingChanged
        )

        return textField
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
        let textField = CustomTextField(placeholder: "Password", isSecure: true)

        textField.addTarget(
            self,
            action: #selector(textFieldEditingChanged),
            for: .editingChanged
        )

        return textField
    }()

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

        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )

        view.addGestureRecognizer(tapGesture)

        configureUI()
    }

}

// MARK: - Helpers

extension RegistrationController {

    private func configureUI() {
        configureGradientBackground()

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
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let fullname = fullNametField.text
        else {
            return
        }

        showLoader()

        AuthService.registerUserWithFirebase(
            with: email,
            password: password,
            fullname: fullname
        ) { result in

            self.showLoader(false)

            switch result {
            case .success(let user):
                self.delegate?.authenticationComplete(with: user)
            case let .failure(error):
                if case .serverError(let message) = error {
                    self.showMessage(withTitle: "Error", message: message)
                }
            }
        }
    }

    @objc private func showLoginController(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @objc private func textFieldEditingChanged(_ sender: UITextField) {
        if sender === emailTextField {
            viewModel.email = sender.text
        } else if sender === passwordTextField {
            viewModel.password = sender.text
        } else if sender === fullNametField {
            viewModel.fullName = sender.text
        }

        updateForm()
    }

}

// MARK: - FormViewModel

extension RegistrationController: FormViewModel {

    func updateForm() {
        signUpButton.isEnabled = viewModel.shouldEnableButton
        signUpButton.backgroundColor = viewModel.buttonBackgroundColor
        signUpButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
    }

}
