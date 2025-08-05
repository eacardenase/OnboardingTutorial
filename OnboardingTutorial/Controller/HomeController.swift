//
//  HomeController.swift
//  OnboardingTutorial
//
//  Created by Edwin Cardenas on 8/2/25.
//

import FirebaseAuth
import UIKit

class HomeController: UIViewController {

    // MARK: - Properties

    private var user: User? {
        didSet {
            presentOnboardingIfNecessary()
            showWelcomeLabel()
        }
    }

    private let welcomeLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 28)
        label.text = "Welcome,"
        label.alpha = 0
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping

        return label
    }()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        authenticateUser()
        configureUI()
    }

}

// MARK: - Helpers

extension HomeController {

    private func configureUI() {
        configureGradientBackground()

        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.title = "Onboarding Tutorial"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person.circle.fill")?.withTintColor(
                .white,
                renderingMode: .alwaysOriginal
            ),
            style: .plain,
            target: self,
            action: #selector(handleLogOut)
        )

        view.addSubview(welcomeLabel)

        // welcomeLabel
        NSLayoutConstraint.activate([
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            welcomeLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            welcomeLabel.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
        ])
    }

    private func presentLoginController() {
        let loginController = LoginController()

        loginController.delegate = self

        let navigationController = UINavigationController(
            rootViewController: loginController
        )

        navigationController.modalPresentationStyle = .fullScreen

        self.present(navigationController, animated: true)
    }

    private func presentOnboardingIfNecessary() {
        guard let user,
            !user.hasSeenOnboarding
        else { return }

        let controller = OnboardingController()

        controller.delegate = self
        controller.modalPresentationStyle = .fullScreen

        navigationController?.present(controller, animated: true)
    }

    private func showWelcomeLabel() {
        guard let user, user.hasSeenOnboarding else { return }

        welcomeLabel.text = "Welcome, \(user.fullname)"

        UIViewPropertyAnimator(duration: 1, curve: .easeIn) {
            self.welcomeLabel.alpha = 1
        }.startAnimation()
    }

}

// MARK: - API

extension HomeController {

    func authenticateUser() {
        AuthService.fetchUser { result in
            switch result {
            case .success(let user):
                self.user = user
            case .failure:
                DispatchQueue.main.async {
                    self.presentLoginController()
                }
            }
        }
    }

    func logout() {
        AuthService.logout {
            self.user = nil
            self.welcomeLabel.alpha = 0

            self.presentLoginController()
        }
    }

}

// MARK: - Actions

extension HomeController {

    @objc func handleLogOut(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(
            title: nil,
            message: "Are you sure you want to sign out?",
            preferredStyle: .actionSheet
        )

        alertController.addAction(
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        alertController.addAction(
            UIAlertAction(title: "Sign Out", style: .destructive) {
                _ in

                self.logout()
            }
        )

        present(alertController, animated: true)
    }

}

// MARK: - OnboardingControllerDelegate

extension HomeController: OnboardingControllerDelegate {

    func controllerWantsToDismiss(_ sender: OnboardingController) {
        sender.dismiss(animated: true)

        AuthService.updateUserHasSeenOnboarding { result in
            switch result {
            case .success:
                self.user?.hasSeenOnboarding = true
            case .failure(let error):
                print("DEBUG: Falied to update user with error: \(error)")
            }
        }
    }

}

// MARK: - AuthenticationDelegate

extension HomeController: AuthenticationDelegate {

    func authenticationComplete(with user: User) {
        dismiss(animated: true)

        self.user = user
    }

}
