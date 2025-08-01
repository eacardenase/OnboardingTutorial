//
//  UIViewController+GradientBackground.swift
//  OnboardingTutorial
//
//  Created by Edwin Cardenas on 8/1/25.
//

import UIKit

extension UIViewController {

    func configureGradientBackground() {
        let gradient = CAGradientLayer()

        gradient.frame = view.frame
        gradient.locations = [0, 1]
        gradient.colors = [
            UIColor.systemPurple.cgColor, UIColor.systemTeal.cgColor,
        ]

        view.layer.addSublayer(gradient)
    }

}
