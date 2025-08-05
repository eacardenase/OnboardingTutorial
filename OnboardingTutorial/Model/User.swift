//
//  User.swift
//  OnboardingTutorial
//
//  Created by Edwin Cardenas on 8/4/25.
//

import Foundation

struct User {

    let uid: String
    let email: String
    let fullname: String
    var hasSeenOnboarding: Bool = false

    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.hasSeenOnboarding = dictionary["hasSeenOnboarding"] as? Bool ?? false
    }

}
