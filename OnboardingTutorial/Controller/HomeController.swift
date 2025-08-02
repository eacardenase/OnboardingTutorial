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

}

// MARK: - API

extension HomeController {

    func authenticateUser() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginController()

                let navigationController = UINavigationController(
                    rootViewController: loginController
                )

                navigationController.modalPresentationStyle = .fullScreen

                self.present(navigationController, animated: true)
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()

            authenticateUser()
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
        logout()
    }

}
