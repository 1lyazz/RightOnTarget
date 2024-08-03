//  Game.swift
//  Cards
//  Created by Ilya Zablotski

import UIKit

class CardGame {
    // Count of unique card pairs
    var cardsCount = 0
    // Generated cards array
    var cards = [Card]()
    // Generation of random cards array
    func generateCards() {
        // Generation new cards array
        var cards = [Card]()
        for _ in 0 ... cardsCount {
            let randomElement = (type: CardType.allCases.randomElement()!, color: CardColor.allCases.randomElement()!)
            cards.append(randomElement)
        }
        self.cards = cards
    }

    // Card equivalence check
    func checkCards(_ firstCard: Card, _ secondCard: Card) -> Bool {
        if firstCard == secondCard {
            return true
        }
        return false
    }
}
