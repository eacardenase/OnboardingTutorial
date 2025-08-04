//
//  OnboardingController.swift
//  OnboardingTutorial
//
//  Created by Edwin Cardenas on 8/4/25.
//

import PaperOnboarding
import UIKit

class OnboardingController: UIViewController {

    // MARK: - Properties

    private var onboardingItems = [OnboardingItemInfo]()
    private var onboardingView = PaperOnboarding()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureOnboardingDataSource()
    }

}

// MARK: - Helpers

extension OnboardingController {

    private func configureUI() {
        view.addSubview(onboardingView)

        NSLayoutConstraint.activate([
            onboardingView.topAnchor.constraint(equalTo: view.topAnchor),
            onboardingView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            onboardingView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            onboardingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func configureOnboardingDataSource() {
        let item1 = OnboardingItemInfo(
            informationImage: UIImage(resource: .baselineInsertChartWhite48Pt)
                .withRenderingMode(.alwaysOriginal),
            title: "Metrics",
            description: "Some description here...",
            pageIcon: UIImage(),
            color: .systemPurple,
            titleColor: .white,
            descriptionColor: .white,
            titleFont: .boldSystemFont(ofSize: 24),
            descriptionFont: .systemFont(ofSize: 16)
        )

        onboardingItems.append(contentsOf: [
            item1, item1, item1,
        ])

        onboardingView.dataSource = self
        onboardingView.reloadInputViews()
    }

}

// MARK: - PaperOnboardingDataSource

extension OnboardingController: PaperOnboardingDataSource {

    func onboardingItemsCount() -> Int {
        return onboardingItems.count
    }

    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return onboardingItems[index]
    }

}
