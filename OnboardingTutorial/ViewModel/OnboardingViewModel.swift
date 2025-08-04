//
//  OnboardingViewModel.swift
//  OnboardingTutorial
//
//  Created by Edwin Cardenas on 8/4/25.
//

import PaperOnboarding

struct OnboardingViewModel {

    private let itemCount: Int

    init(itemCount: Int) {
        self.itemCount = itemCount
    }

    func shouldShowGetStartedButton(forIndex index: Int) -> Bool {
        return index == itemCount - 1
    }

}
