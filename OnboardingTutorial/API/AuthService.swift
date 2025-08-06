//
//  AuthService.swift
//  OnboardingTutorial
//
//  Created by Edwin Cardenas on 8/3/25.
//

import FirebaseAuth
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
        useFirestore: Bool = true,
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

            fetchUser(useFirestore: useFirestore, completion: completion)
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
        useFirestore: Bool = true,
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
                useFirestore: useFirestore,
                completion: completion
            )
        }
    }

    static func signInWithGoogle(
        withPresenting presentingViewController: UIViewController,
        useFirestore: Bool = true,
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

                fetchUser(useFirestore: useFirestore) { result in
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
                            useFirestore: useFirestore,
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
        useFirestore: Bool = true,
        completion: @escaping (Result<User, AuthError>) -> Void
    ) {
        let values: [String: Any] = [
            "email": data["email"] ?? "",
            "fullname": data["fullname"] ?? "",
            "hasSeenOnboarding": false,
        ]

        if useFirestore {
            Constants.FirebaseFirestore.USERS_COLLECTION.document(uid).setData(
                values
            ) { error in
                if let error {
                    completion(
                        .failure(.serverError(error.localizedDescription))
                    )

                    return
                }

                fetchUser(useFirestore: true, completion: completion)
            }

            return
        }

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
        useFirestore: Bool = true,
        completion: @escaping (Result<User, AuthError>) -> Void
    ) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(
                .failure(.serverError("There is no user currently logged in"))
            )

            return
        }

        if useFirestore {
            Constants.FirebaseFirestore.USERS_COLLECTION.document(uid)
                .getDocument { snapshot, error in
                    if let error {
                        completion(
                            .failure(.serverError(error.localizedDescription))
                        )

                        return
                    }

                    guard let snapshot,
                        snapshot.exists,
                        let userData = snapshot.data()
                    else {
                        completion(
                            .failure(.serverError("User data not found"))
                        )

                        return
                    }

                    let user = User(uid: uid, dictionary: userData)

                    completion(.success(user))
                }

            return
        }

        Constants.FirebaseDatabase.REF_USERS.child(uid).observeSingleEvent(
            of: .value
        ) { snapshot in
            let uid = snapshot.key

            guard let dictionary = snapshot.value as? [String: Any] else {
                completion(.failure(.serverError("User data not found")))

                return
            }

            let user = User(uid: uid, dictionary: dictionary)

            completion(.success(user))
        }
    }

    static func updateUserHasSeenOnboarding(
        useFirestore: Bool = true,
        completion: @escaping (Result<User, AuthError>) -> Void
    ) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(.serverError("There is not user logged in")))

            return
        }

        if useFirestore {
            Constants.FirebaseFirestore.USERS_COLLECTION.document(uid)
                .updateData([
                    "hasSeenOnboarding": true
                ]) { error in
                    if let error {
                        completion(
                            .failure(.serverError(error.localizedDescription))
                        )

                        return
                    }

                    fetchUser(completion: completion)
                }

            return
        }

        Constants.FirebaseDatabase.REF_USERS.child(uid).child(
            "hasSeenOnboarding"
        ).setValue(true) { error, ref in
            if let error {
                completion(.failure(.serverError(error.localizedDescription)))

                return
            }

            fetchUser(useFirestore: false, completion: completion)
        }
    }

    static func resetPassword(
        withEmail email: String,
        completion: @escaping (Error?) -> Void
    ) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: completion)
    }

}
