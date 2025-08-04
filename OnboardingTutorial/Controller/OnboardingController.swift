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

    private lazy var getStartedButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Get started", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)
        button.alpha = 0
        button.addTarget(
            self,
            action: #selector(dismissOnboarding),
            for: .touchUpInside
        )

        return button
    }()

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
        view.addSubview(getStartedButton)

        // onboardingView
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

        // getStartedButton
        NSLayoutConstraint.activate([
            getStartedButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            getStartedButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -128
            ),
        ])
    }

    private func configureOnboardingDataSource() {
        let item1 = OnboardingItemInfo(
            informationImage: UIImage(resource: .baselineInsertChartWhite48Pt)
                .withRenderingMode(.alwaysOriginal),
            title: Constants.OnboardingContent.MSG_METRICS,
            description: Constants.OnboardingContent.MSG_ONBOARDING_METRICS,
            pageIcon: UIImage(),
            color: .systemPurple,
            titleColor: .white,
            descriptionColor: .white,
            titleFont: .boldSystemFont(ofSize: 24),
            descriptionFont: .systemFont(ofSize: 16)
        )

        let item2 = OnboardingItemInfo(
            informationImage: UIImage(resource: .baselineDashboardWhite48Pt)
                .withRenderingMode(.alwaysOriginal),
            title: Constants.OnboardingContent.MSG_DASHBOARD,
            description: Constants.OnboardingContent.MSG_ONBOARDING_DASHBOARD,
            pageIcon: UIImage(),
            color: .systemBlue,
            titleColor: .white,
            descriptionColor: .white,
            titleFont: .boldSystemFont(ofSize: 24),
            descriptionFont: .systemFont(ofSize: 16)
        )

        let item3 = OnboardingItemInfo(
            informationImage: UIImage(
                resource: .baselineNotificationsActiveWhite48Pt
            )
            .withRenderingMode(.alwaysOriginal),
            title: Constants.OnboardingContent.MSG_NOTIFICATIONS,
            description: Constants.OnboardingContent
                .MSG_ONBOARDING_NOTIFICATIONS,
            pageIcon: UIImage(),
            color: .systemPink,
            titleColor: .white,
            descriptionColor: .white,
            titleFont: .boldSystemFont(ofSize: 24),
            descriptionFont: .systemFont(ofSize: 16)
        )

        onboardingItems.append(contentsOf: [
            item1, item2, item3,
        ])

        onboardingView.dataSource = self
        onboardingView.delegate = self

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

// MARK: - Actions

extension OnboardingController {

    @objc private func dismissOnboarding(_ sender: UIButton) {
        print("DEBUG: This should not be run")
    }

}

// MARK: - PaperOnboardingDelegate

extension OnboardingController: PaperOnboardingDelegate {

    func onboardingWillTransitonToIndex(_ index: Int) {
        let isLastOnboardingItem = index == self.onboardingItems.count - 1

        UIViewPropertyAnimator(duration: 0.35, curve: .easeInOut) {
            self.getStartedButton.alpha = isLastOnboardingItem ? 1 : 0
        }.startAnimation()
    }

}
