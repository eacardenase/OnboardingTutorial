//
//  CustomTextField.swift
//  OnboardingTutorial
//
//  Created by Edwin Cardenas on 8/1/25.
//

import UIKit

class CustomTextField: UITextField {

    init(placeholder: String, isSecure secure: Bool = false) {
        super.init(frame: .zero)

        let spacer = UIView()

        spacer.widthAnchor.constraint(equalToConstant: 12).isActive = true

        leftView = spacer
        leftViewMode = .always
        rightView = spacer
        rightViewMode = .always

        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 8
        borderStyle = .none
        textColor = .white
        keyboardAppearance = .dark
        keyboardType = .asciiCapable
        autocorrectionType = .no
        backgroundColor = UIColor(white: 1, alpha: 0.1)
        isSecureTextEntry = secure
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)]
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: 12, height: 50)
    }

}
