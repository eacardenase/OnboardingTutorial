//
//  AuthService.swift
//  OnboardingTutorial
//
//  Created by Edwin Cardenas on 8/3/25.
//

import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn

enum AuthError: Error {
    case serverError(String)
    case decodingError
}

struct AuthService {

    private init() {}

    static func logUserIn(
        with email: String,
        password: String,
        completion: @escaping (Result<User, AuthError>) -> Void
    ) {
        Auth.auth().signIn(
            withEmail: email,
            password: password
        ) { result, error in
            if let error {
                completion(.failure(.serverError(error.localizedDescription)))

                return
            }

            fetchUser(completion: completion)
        }
    }

    static func logout(completion: @escaping () -> Void) {
        do {
            try Auth.auth().signOut()

            completion()
        } catch {
            print(
                "DEBUG: Error during signing out with error: \(error.localizedDescription)"
            )
        }
    }

    static func registerUserWithFirebase(
        with email: String,
        password: String,
        fullname: String,
        completion: @escaping (Result<User, AuthError>) -> Void
    ) {
        Auth.auth().createUser(withEmail: email, password: password) {
            result,
            error in

            if let error {
                completion(.failure(.serverError(error.localizedDescription)))

                return
            }

            guard let uid = result?.user.uid else { return }

            let values = [
                "email": email,
                "fullname": fullname,
            ]

            signUpFirebaseUser(
                withUid: uid,
                data: values,
                completion: completion
            )
        }
    }

    static func signInWithGoogle(
        withPresenting presentingViewController: UIViewController,
        completion: @escaping (Result<User, AuthError>) -> Void
    ) {
        GIDSignIn.sharedInstance.signIn(
            withPresenting: presentingViewController
        ) {
            signInResult,
            error in

            if let error {
                completion(.failure(.serverError(error.localizedDescription)))
            }

            guard let signInResult else {
                completion(
                    .failure(
                        .serverError("DEBUG: Found nil in Google signInResult")
                    )
                )

                return
            }

            let user = signInResult.user

            guard let userId = user.idToken,
                let email = user.profile?.email,
                let fullname = user.profile?.name
            else {
                completion(
                    .failure(
                        .serverError(
                            "DEBUG: Error getting user details from Google"
                        )
                    )
                )

                return
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: userId.tokenString,
                accessToken: user.accessToken.tokenString
            )

            Auth.auth().signIn(with: credential) { result, error in
                if let error {
                    completion(
                        .failure(.serverError(error.localizedDescription))
                    )

                    return
                }

                guard let uid = result?.user.uid else {
                    return
                }

                fetchUser { result in
                    switch result {
                    case .success(let user):
                        completion(.success(user))
                    case .failure:
                        let values = [
                            "email": email,
                            "fullname": fullname,
                        ]

                        signUpFirebaseUser(
                            withUid: uid,
                            data: values,
                            completion: completion
                        )
                    }
                }
            }
        }
    }

    static func signUpFirebaseUser(
        withUid uid: String,
        data: [String: String],
        completion: @escaping (Result<User, AuthError>) -> Void
    ) {
        let values: [String: Any] = [
            "email": data["email"] ?? "",
            "fullname": data["fullname"] ?? "",
            "hasSeenOnboarding": false,
        ]

        Constants.FirebaseDatabase.REF_USERS.child(uid)
            .updateChildValues(values) { error, ref in
                if let error {
                    completion(
                        .failure(.serverError(error.localizedDescription))
                    )

                    return
                }

                fetchUser(completion: completion)
            }
    }

    static func fetchUser(
        completion: @escaping (Result<User, AuthError>) -> Void
    ) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(
                .failure(.serverError("There is no user currently logged in"))
            )

            return
        }

        Constants.FirebaseDatabase.REF_USERS.child(uid).observeSingleEvent(
            of: .value
        ) { snapshot in
            let uid = snapshot.key

            guard let dictionary = snapshot.value as? [String: Any] else {
                print("DEBUG: user not found")

                completion(.failure(.decodingError))

                return
            }

            let user = User(uid: uid, dictionary: dictionary)

            completion(.success(user))
        }
    }

    static func updateUserHasSeenOnboarding(
        completion: @escaping (Result<User, AuthError>) -> Void
    ) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }

        Constants.FirebaseDatabase.REF_USERS.child(uid).child(
            "hasSeenOnboarding"
        ).setValue(true) { error, ref in
            if let error {
                completion(.failure(.serverError(error.localizedDescription)))
            }

            fetchUser(completion: completion)
        }
    }

    static func resetPassword(
        withEmail email: String,
        completion: @escaping (Error?) -> Void
    ) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: completion)
    }

}
