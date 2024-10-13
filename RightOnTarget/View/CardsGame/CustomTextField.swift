//  CustomTextField.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import UIKit

class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        // Appearance
        layer.cornerRadius = 15
        backgroundColor = .white
        tintColor = .red
        textColor = .red
        font = UIFont.boldSystemFont(ofSize: 20)
        textAlignment = .center

        // Shadow
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
        layer.shadowRadius = 4

        // Placeholder
        attributedPlaceholder = NSAttributedString(
            string: "Enter your name",
            attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 0.8496571183, blue: 0.9784039855, alpha: 1)]
        )

        // Keyboard settings
        keyboardType = .asciiCapable
        minimumFontSize = 15
        adjustsFontSizeToFitWidth = true
    }
}
