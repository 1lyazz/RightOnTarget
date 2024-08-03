//  ColorGame.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import Feedbacks
import UIKit

protocol ColorGameProtocol {
    // Number of game points
    var score: Int { get }
    // "Secret" color from random
    var currentSecretColor: UIColor { get }
    // Game-ending check
    var isGameEnded: Bool { get }
    // Starts new game and back to first round
    func restartGame()
    // starts a new round (+ updates "Secret" color)
    func startNewRound()
    // Match user color choice with "Secret" color and calculate game points
    func calculateScore(with value: UIColor)
}

class ColorGame: ColorGameProtocol {
    private var secretColorsArray: [UIColor]
    private var originalColorsArray: [UIColor]
    private var lastRound: Int
    var score: Int = 0 {
        didSet {
            if score > oldValue {
                shakeScreen()
            }
        }
    }

    var currentRound: Int = 1
    var currentSecretColor: UIColor = .clear
    var isGameEnded: Bool {
        return currentRound >= lastRound
    }
    
    init?(secretColorsArray: [UIColor], rounds: Int) {
        guard secretColorsArray.count == rounds else {
            return nil
        }
        self.secretColorsArray = secretColorsArray
        originalColorsArray = secretColorsArray
        lastRound = rounds
        currentSecretColor = getNewSecretColor()
    }
    
    func restartGame() {
        currentRound = 0
        score = 0
        secretColorsArray = originalColorsArray
        startNewRound()
    }
    
    func startNewRound() {
        currentSecretColor = getNewSecretColor()
        currentRound += 1
    }
    
    private func getNewSecretColor() -> UIColor {
        secretColorsArray.remove(at: Int.random(in: 0 ..< secretColorsArray.count))
    }
    
    func getSecretColorHex() -> String {
        currentSecretColor.colorHex ?? ""
    }
    
    func calculateScore(with value: UIColor) {
        if value == currentSecretColor {
            score += 1
            playSound(sound: "success", type: "mp3")
        } else {
            playSound(sound: "failure", type: "mp3")
        }
    }
    
    private func shakeScreen() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
}

extension UIColor {
    var colorHex: String? {
        guard let components = cgColor.components else { return nil }
        let len = components.count
        var color: String?
        
        if len >= 4 {
            let r = components[0]
            let g = components[1]
            let b = components[2]
            color = String(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        } else if len >= 2 {
            let gray = components[0]
            color = String(format: "#%02lX%02lX%02lX", lroundf(Float(gray * 255)), lroundf(Float(gray * 255)), lroundf(Float(gray * 255)))
        }
        
        return color
    }
}
