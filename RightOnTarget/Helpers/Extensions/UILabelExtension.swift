//  UILabelExtension.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import UIKit

extension UILabel {
    func setLabelStyle(font: UIFont, textColor: UIColor, textAlignment: NSTextAlignment? = .center, numberOfLines: Int? = 1) {
        guard let textAlignment = textAlignment,
              let numberOfLines = numberOfLines
        else { return }

        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }
    
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }
}
