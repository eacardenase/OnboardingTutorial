//
//  AuthenticationViewModel.swift
//  OnboardingTutorial
//
//  Created by Edwin Cardenas on 8/2/25.
//

import UIKit

struct LoginViewModel {

    var email: String?
    var password: String?

    var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty == false
    }

    var shouldEnableButton: Bool {
        formIsValid
    }

    var buttonTitleColor: UIColor {
        return formIsValid ? .white : .white.withAlphaComponent(0.67)
    }

    var buttonBackgroundColor: UIColor {
        return formIsValid
            ? .systemPurple : .systemPurple.withAlphaComponent(0.5)
    }

}

struct RegistrationViewModel {

}

struct ResetPasswordViewModel {

}
