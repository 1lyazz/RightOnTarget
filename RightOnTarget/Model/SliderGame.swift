//  Game.swift
//  Right on target
//  Created by Ilya Zablotski

protocol SliderGameProtocol {
    // Number of game points
    var score: Int { get }
    // "Secret" number from random
    var currentSecretValue: Int { get }
    // Game-ending check
    var isGameEnded: Bool { get }
    // Starts new game and back to first round
    func restartGame()
    // starts a new round (+ updates "Secret" number)
    func startNewRound()
    // Match user number (from slider) with "Secret" number and calculate game points
    func calculateScore(with value: Int)
}

class SliderGame: SliderGameProtocol {
    // Number of rounds
    private var lastRound: Int
    // Min secret number
    private var minSecretValue: Int
    // Max secret number
    private var maxSecretValue: Int
    var currentSecretValue: Int = 0
    var score: Int = 0
    var currentRound: Int = 1
    var isGameEnded: Bool {
        return currentRound >= lastRound
    }

    init?(startValue: Int, endValue: Int, rounds: Int) {
        /// Check: The starting value for selecting a random number cannot be greater than the ending value
        /// guard activated when false
        guard startValue <= endValue else {
            return nil
        }
        minSecretValue = startValue
        maxSecretValue = endValue
        lastRound = rounds
        currentSecretValue = getNewSecretValue()
    }

    func restartGame() {
        currentRound = 0
        score = 0
        startNewRound()
    }

    func startNewRound() {
        currentSecretValue = getNewSecretValue()
        currentRound += 1
    }

    // Make and return secret number
    private func getNewSecretValue() -> Int {
        (minSecretValue ... maxSecretValue).randomElement()!
    }

    // Calculate game points
    func calculateScore(with value: Int) {
        score += 50 - abs(currentSecretValue - value)
    }
}
