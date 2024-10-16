//  UIButtonExtension.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import AVFoundation
import Foundation
import UIKit

extension UIButton {
    // Style for app buttons
    func setAppButtonStyle(backgroundImage: String, title: String? = "", titleColor: UIColor? = .clear) {
        guard let title = title,
              let titleColor = titleColor
        else { return }

        let attributedTitle = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
        setAttributedTitle(attributedTitle, for: .normal)
        setTitleColor(titleColor, for: .normal)
        setBackgroundImage(UIImage(named: backgroundImage), for: .normal)
        setShadow()
    }

    // Style for HEX game color buttons
    func setColorButtonShape() {
        layer.cornerRadius = 15
        clipsToBounds = true
        snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(150)
        }
        setShadow()
    }

    // Shadow for buttons
    func setShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 4.0
        layer.masksToBounds = false
    }

    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let minimumHitArea = CGSize(width: 100, height: 100)
        let buttonBounds = bounds
        let widthToAdd = max(minimumHitArea.width - buttonBounds.width, 0)
        let heightToAdd = max(minimumHitArea.height - buttonBounds.height, 0)
        let extendedBounds = buttonBounds.insetBy(dx: -widthToAdd / 2, dy: -heightToAdd / 2)
        return extendedBounds.contains(point) ? self : nil
    }
}
