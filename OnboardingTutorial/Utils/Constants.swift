//
//  Constants.swift
//  OnboardingTutorial
//
//  Created by Edwin Cardenas on 8/4/25.
//

import FirebaseDatabase
import FirebaseFirestore
import Foundation

struct Constants {

    struct OnboardingContent {
        static let MSG_METRICS = "Metrics"
        static let MSG_DASHBOARD = "Dashboard"
        static let MSG_NOTIFICATIONS = "Get Notified"

        static let MSG_ONBOARDING_METRICS =
            "Extract valuable insights and come up with data driven product initiatives to help grow your business"
        static let MSG_ONBOARDING_DASHBOARD =
            "Everything you need all in one place, available through our dashboard feature"
        static let MSG_ONBOARDING_NOTIFICATIONS =
            "Get notified when important stuff is happening, so you don't miss out on the action"
    }

    struct FirebaseDatabase {
        static let DB_REF = Database.database().reference()
        static let REF_USERS = DB_REF.child("users")
    }

    struct FirebaseFirestore {
        static let USERS_COLLECTION = Firestore.firestore().collection("users")
    }

}
