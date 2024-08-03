//  Constants.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import UIKit
import SwiftUI

enum Constants {
    static let colorGameGradient: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.gray.cgColor, UIColor.darkText.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        return layer
    }()
}
