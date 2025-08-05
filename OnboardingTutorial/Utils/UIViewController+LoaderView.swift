//
//  UIViewController+LoaderView.swift
//  OnboardingTutorial
//
//  Created by Edwin Cardenas on 8/5/25.
//

import JGProgressHUD
import UIKit

extension UIViewController {

    static let hud = JGProgressHUD(style: .dark)

    func showLoader(_ show: Bool = true) {
        view.endEditing(true)

        if show {
            UIViewController.hud.show(in: view)
        } else {
            UIViewController.hud.dismiss()
        }
    }

}
