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
        }
    }

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
    }

    private func presentLoginController() {
        let loginController = LoginController()

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

}

// MARK: - API

extension HomeController {

    func authenticateUser() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                self.presentLoginController()
            }

            return
        }

        fetchUser()
    }

    func fetchUser() {
        AuthService.fetchUser { user in
            self.user = user
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()

            self.presentLoginController()
        } catch {
            print(
                "DEBUG: Error during signing out with error: \(error.localizedDescription)"
            )
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

        AuthService.updateUserHasSeenOnboarding { error, ref in
            self.user?.hasSeenOnboarding = true

            print("DEBUG: Did set has seen onboarding")
        }
    }

}
