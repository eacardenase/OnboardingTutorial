//
//  AuthService.swift
//  OnboardingTutorial
//
//  Created by Edwin Cardenas on 8/3/25.
//

import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn

struct AuthService {

    static func logUserIn(
        with email: String,
        password: String,
        completion: @escaping (AuthDataResult?, Error?) -> Void
    ) {
        Auth.auth().signIn(
            withEmail: email,
            password: password,
            completion: completion
        )
    }

    static func registerUserWithFirebase(
        with email: String,
        password: String,
        fullname: String,
        completion: @escaping (Error?, DatabaseReference) -> Void
    ) {
        Auth.auth().createUser(withEmail: email, password: password) {
            result,
            error in

            if let error {
                print(
                    "DEBUG: Failed to create user with error: \(error.localizedDescription)"
                )

                return
            }

            guard let uid = result?.user.uid else { return }

            let values = [
                "email": email,
                "fullname": fullname,
            ]

            Database.database().reference().child("users").child(uid)
                .updateChildValues(values, withCompletionBlock: completion)
        }
    }

    static func signInWithGoogle(
        withPresenting presentingViewController: UIViewController,
        completion: @escaping (Error?, DatabaseReference) -> Void
    ) {
        GIDSignIn.sharedInstance.signIn(
            withPresenting: presentingViewController
        ) {
            signInResult,
            error in

            guard error == nil else {
                return
            }

            guard let signInResult = signInResult else {
                return
            }

            let user = signInResult.user

            guard let userId = user.idToken,
                let email = user.profile?.email,
                let fullname = user.profile?.name
            else {
                return
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: userId.tokenString,
                accessToken: user.accessToken.tokenString
            )

            Auth.auth().signIn(with: credential) { result, error in
                if let error {
                    print(
                        "DEBUG: Failed to sign in with Google: \(error.localizedDescription)"
                    )

                    return
                }

                guard let uid = result?.user.uid else {
                    return
                }

                let values = [
                    "email": email,
                    "fullname": fullname,
                ]

                Database.database().reference().child("users").child(uid)
                    .updateChildValues(values, withCompletionBlock: completion)
            }
        }
    }

}
