//  Card.swift
//  Cards
//  Created by Ilya Zablotski

import Foundation
import UIKit

// Card shape types
enum CardType: CaseIterable {
    case circle
    case cross
    case square
    case fill
}

// Card colors
enum CardColor: CaseIterable {
    case red
    case green
    case black
    case gray
    case brown
    case yellow
    case purple
    case orange
}

typealias Card = (type: CardType, color: CardColor)
