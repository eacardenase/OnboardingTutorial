//
//  AuthenticationViewModel.swift
//  OnboardingTutorial
//
//  Created by Edwin Cardenas on 8/2/25.
//

import Foundation

struct LoginViewModel {

    var email: String?
    var password: String?

    var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty == false
    }

}

struct RegistrationViewModel {

}

struct ResetPasswordViewModel {

}
