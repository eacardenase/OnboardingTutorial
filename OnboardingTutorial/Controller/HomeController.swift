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
            image: UIImage(systemName: "person")?.withTintColor(
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

    }

    func logout() {
        do {
            try Auth.auth().signOut()
            
            print("DEBUG: User signed out")
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
