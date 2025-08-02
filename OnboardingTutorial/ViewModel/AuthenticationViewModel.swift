//
//  AuthenticationViewModel.swift
//  OnboardingTutorial
//
//  Created by Edwin Cardenas on 8/2/25.
//

import UIKit

protocol FormViewModel {
    
    func updateForm()
    
}

protocol AuthenticationViewModel {

    var formIsValid: Bool { get }
    var shouldEnableButton: Bool { get }
    var buttonTitleColor: UIColor { get }
    var buttonBackgroundColor: UIColor { get }

}

extension AuthenticationViewModel {

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

struct LoginViewModel: AuthenticationViewModel {

    var email: String?
    var password: String?

    var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty == false
    }

}

struct RegistrationViewModel: AuthenticationViewModel {

    var email: String?
    var password: String?
    var fullName: String?

    var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty == false
            && fullName?.isEmpty == false
    }

}

struct ResetPasswordViewModel: AuthenticationViewModel {

    var email: String?

    var formIsValid: Bool {
        return email?.isEmpty == false
    }

}
