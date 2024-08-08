//  Game1VC.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import Feedbacks
import SnapKit
import Toast
import UIKit

final class CardsGameVC: UIViewController {
    
    private let cardGameView = CardGameView()
    private lazy var scoreLabel = cardGameView.scoreLabel
    private lazy var homeButton = cardGameView.homeButton
    private lazy var infoButton = cardGameView.infoButton
    private lazy var startButton = cardGameView.startButton
    private lazy var errorLabel = cardGameView.errorLabel
    private lazy var nameTextField = cardGameView.nameTextField
    private lazy var boardGameView = cardGameView.boardGameView
    private lazy var nameLabel = cardGameView.nameLabel
    private lazy var timerLabel = cardGameView.timerLabel
    
    private lazy var countTimer = cardGameView.countTimer
    private lazy var totalTime = cardGameView.totalTime
    
    // "Game" entity
    lazy var game: CardGame = getNewGame()
    // Count of unique card pairs
    var cardsPairsCounts: Int = 9
    // Card sizes
    private var cardSize: CGSize { CGSize(width: 60, height: 100) }
    // Game cards (views array)
    var cardViews = [UIView]()
    // Flipped cards (when cards fronted)
    private var flippedCards = [UIView]()
    
    // Start / Restart Bckd image
    var backgroundImageState: Int = 0
        
    var userName: String = ""
    
    var gameScore: Int = 0 {
        didSet {
            if gameScore != oldValue {
                scoreLabel.text = "Score \(gameScore)"
            }
        }
    }
    
    // MARK: - Lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        makeConstraints()
        bind()
        
        nameTextField.delegate = self
        
        // Hiding the keyboard by tapping the screen
        setupGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MusicPlayer.shared.startBackgroundMusic(backgroundMusicFileName: "game")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scoreLabel.text = "Score \(gameScore)"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        countTimer?.invalidate()
    }
}

// MARK: Private Methods

private extension CardsGameVC {
    // MARK: Setup View
    
    private func setupView() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "CardGameBackground")!)
        view.addSubview(cardGameView)
    }
    
    // MARK: Constraints
    
    private func makeConstraints() {
        cardGameView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: Bindings
    
    private func bind() {
        homeButton.addAction(UIAction(handler: { [weak self] _ in
            self?.handleHomeButtonTap()
        }), for: .touchUpInside)
        
        infoButton.addAction(UIAction(handler: { [weak self] _ in
            self?.handleInfoButtonTap()
        }), for: .touchUpInside)
        
        startButton.addAction(UIAction(title: "", handler: { [weak self] _ in
            self?.handleStartButtonTap()
        }), for: .touchUpInside)
    }
    
    private func handleHomeButtonTap() {
        playClickSound()
        dismiss(animated: true, completion: nil)
        MusicPlayer.shared.stopBackgroundMusic()
    }
    
    private func handleInfoButtonTap() {
        playClickSound()
        cardGameView.showAlertWith(alertType: .infoAlert)
    }
    
    private func handleStartButtonTap() {
        checkNameField()
        guard errorLabel.isHidden else { return }
        
        nameTextField.resignFirstResponder()
        boardGameView.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.boardGameView.isUserInteractionEnabled = true
        }
        
        playSound(sound: "startGame", type: "mp3")
        nameLabel.text = nameTextField.text
        
        cardGameView.animateStartButton()
        
        let newGame = getNewGame()
        game = newGame
        let cards = getCardsBy(modelData: newGame.cards)
        placeCardsOnBoard(cards)
    }
    
    private func playClickSound() {
        playSound(sound: "click", type: "wav")
    }
}

// MARK: Game Process

private extension CardsGameVC {
    // Preparing new game
    private func getNewGame() -> CardGame {
        let game = CardGame()
        gameScore = 0
        game.cardsCount = cardsPairsCounts
        game.generateCards()
        return game
    }
    
    // Card array generation
    private func getCardsBy(modelData: [Card]) -> [UIView] {
        // Cards view array
        var cardViews = [UIView]()
        // Card factory
        let cardViewFactory = CardViewFactory()
        
        for (index, modelCard) in modelData.enumerated() {
            // Add first card instance
            let cardOne = cardViewFactory.get(modelCard.type, withSize: cardSize,
                                              andColor: modelCard.color)
            cardOne.tag = index
            cardViews.append(cardOne)
            // Add second card instance
            let cardTwo = cardViewFactory.get(modelCard.type, withSize: cardSize,
                                              andColor: modelCard.color)
            cardTwo.tag = index
            cardViews.append(cardTwo)
        }
        
        // Add flip handler
        for card in cardViews {
            (card as! FlippableView).flipCompletionHandler = { flippedCard in
                // Move the card up the hierarchy
                flippedCard.superview?.bringSubviewToFront(flippedCard)
                
                // Add or delete card
                if flippedCard.isFlipped {
                    self.flippedCards.append(flippedCard)
                } else {
                    if let cardIndex = self.flippedCards.firstIndex(of: flippedCard) {
                        self.flippedCards.remove(at: cardIndex)
                    }
                }
                
                // If two cards is flipped (when cards fronted)
                if self.flippedCards.count == 2 {
                    // Get cards from model data
                    let firstCard = self.game.cards[self.flippedCards.first!.tag]
                    let secondCard = self.game.cards[self.flippedCards.last!.tag]
                    
                    // If cards is equal (match)
                    if self.game.checkCards(firstCard, secondCard) {
                        self.gameScore += 5
                        playSound(sound: "success", type: "mp3")
                        // Animatedly hide cards
                        UIView.animate(withDuration: 0.1, animations: {
                            self.flippedCards.first!.layer.opacity = 0
                            self.flippedCards.first!.removeFromSuperview()
                            self.flippedCards.last!.layer.opacity = 0
                            self.flippedCards.last!.removeFromSuperview()
                            // Remove from hierarchy
                        }, completion: { _ in
                            self.flippedCards = []
                        })
                        
                        guard self.gameScore != (self.cardsPairsCounts + 1) * 5 else {
                            self.cardGameView.showAlertWith(alertType: .scoreAlert, score: self.gameScore, totalTime: self.totalTime)
                            self.countTimer?.invalidate()
                            UIView.animate(withDuration: 0.5) {
                                self.startButton.snp.remakeConstraints { make in
                                    make.centerX.equalToSuperview()
                                    make.centerY.equalToSuperview()
                                    make.width.equalTo(340)
                                    make.height.equalTo(104)
                                }
                                
                                self.nameTextField.snp.remakeConstraints { make in
                                    make.centerX.equalToSuperview()
                                    make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(20)
                                    make.width.equalTo(200)
                                    make.height.equalTo(40)
                                }
                            }
                            
                            // Set data to UserDefaults
                            self.savePlayerData(userName: self.userName, totalTime: self.totalTime)
                            
                            return
                        }
                        // If cards isn't equal (difference)
                    } else {
                        playSound(sound: "failure", type: "mp3")
                        // Flip cards over to the back side (shirt side)
                        for card in self.flippedCards {
                            (card as! FlippableView).flip()
                            self.flippedCards.removeAll()
                        }
                    }
                }
            }
        }
        
        return cardViews
    }
    
    private func savePlayerData(userName: String, totalTime: Int) {
        var players = UserDefaults.standard.dictionary(forKey: "players") as? [String: Int] ?? [:]
        var isNewRecord = false
        
        if let existingTime = players[userName] {
            if totalTime < existingTime {
                players[userName] = totalTime
                isNewRecord = true
            }
        } else {
            players[userName] = totalTime
            isNewRecord = true
        }
        
        UserDefaults.standard.set(players, forKey: "players")
        
        if isNewRecord, players.values.min() == totalTime {
            self.view.makeToast("🏆 NEW RECORD 🏆", duration: 3.0, position: .top)
        }
    }

    // Place cards on board
    private func placeCardsOnBoard(_ cards: [UIView]) {
        // Delete all cards from game board
        for card in cardViews {
            card.removeFromSuperview()
        }
        cardViews = cards
        cardViews.shuffle()
        
        // Number of stack rows and columns
        let numRows = 2
        let numColumns = 10
        
        // Vertical & Horizontal spacing
        let horizontalSpacing = 5
        let verticalSpacing = 5
        
        // Cards width & height
        let cardWidth = Int(cardSize.width)
        let cardHeight = Int(cardSize.height)
        
        // Total stack width & height
        let totalStackWidth = numColumns * cardWidth + (numColumns - 1) * horizontalSpacing
        let totalStackHeight = numRows * cardHeight + (numRows - 1) * verticalSpacing
        
        // Initial stack coordinates
        let initialX = (Int(boardGameView.frame.width) - totalStackWidth) / 2
        let initialY = (Int(boardGameView.frame.height) - totalStackHeight) / 2
        
        for (index, card) in cardViews.enumerated() {
            let row = index / numColumns
            let column = index % numColumns
            
            let xCoordinate = initialX + column * (Int(cardSize.width) + horizontalSpacing)
            let yCoordinate = initialY + row * (Int(cardSize.height) + verticalSpacing)
            
            card.frame.origin = CGPoint(x: xCoordinate, y: yCoordinate)
            boardGameView.addSubview(card)
        }
        
        // Update start button background
        func updateBackgroundImage() {
            switch backgroundImageState {
            case 0:
                startButton.setBackgroundImage(UIImage(named: "CardsRestratButton"), for: .normal)
                backgroundImageState += 1
            case 1:
                startButton.setBackgroundImage(UIImage(named: "CardsRestratPinkButton"), for: .normal)
                backgroundImageState += 1
            case 2:
                startButton.setBackgroundImage(UIImage(named: "CardsRestratBlueButton"), for: .normal)
                backgroundImageState = 0
            case 3:
                startButton.setBackgroundImage(UIImage(named: "CardsStratButton"), for: .normal)
            default:
                break
            }
        }
        
        // Flip start button to the next state
        UIView.transition(with: startButton, duration: 0.3, options: .transitionFlipFromTop, animations: {
            updateBackgroundImage()
        }, completion: { _ in
            for card in self.cardViews {
                (card as! FlippableView).startFlip()
            }
            self.startTimer()
        })
    }
    
    // Starting game timer
    private func startTimer() {
        countTimer?.invalidate()
        playSound(sound: "startTimer", type: "mp3")
        totalTime = 0
        countTimer = Timer.scheduledTimer(timeInterval: 1, target: self,
                                          selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        totalTime += 1
        timerLabel.text = "\(totalTime)"
    }
}

// MARK: - UITextFieldDelegate

extension CardsGameVC: UITextFieldDelegate {
    // Actions after pressing return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        checkNameField()
                        
        return true
    }
    
    // Checking for empty input field
    private func checkNameField() {
        guard let name = nameTextField.text, !name.isEmpty else {
            UIView.animate(withDuration: 0.5) {
                self.errorLabel.isHidden = false
                self.errorLabel.alpha = 1
            }
            
            return
        }
        userName = name
        errorLabel.isHidden = true
        errorLabel.alpha = 0
    }
}
