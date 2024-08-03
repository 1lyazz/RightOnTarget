//  Game1VC.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import Feedbacks
import SnapKit
import UIKit

class CardsGameVC: UIViewController, UITextFieldDelegate {
    private let alert = CustomAlert(gameType: .cardGame)
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
    
    var countTimer: Timer?
    var totalTime: Int = 0
    
    var userName: String = ""
    
    var gameScore: Int = 0 {
        didSet {
            if gameScore != oldValue {
                scoreLabel.text = "Score \(gameScore)"
            }
        }
    }
    
    // MARK: Scene Elements
    
    private let homeButton: UIButton = {
        let button = UIButton()
        button.setAppButtonStyle(backgroundImage: "CardsHomeButton")
        return button
    }()
    
    private let infoButton: UIButton = {
        let button = UIButton()
        button.setAppButtonStyle(backgroundImage: "CardsInfoButton")
        return button
    }()
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.setAppButtonStyle(backgroundImage: "CardsStratButton")
        return button
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 15
        textField.backgroundColor = .white
        textField.tintColor = .red
        
        textField.layer.shadowOpacity = 0.5
        textField.layer.shadowOffset = .zero
        textField.layer.shadowRadius = 4
        
        textField.attributedPlaceholder = NSAttributedString(string: "Enter your name", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 0.8496571183, blue: 0.9784039855, alpha: 1)])
        textField.textAlignment = .center
        textField.font = UIFont.boldSystemFont(ofSize: 20)
        textField.textColor = .red
        
        textField.keyboardType = .asciiCapable
        
        return textField
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(font: .systemFont(ofSize: 18), textColor: .red)
        label.text = "Please enter your name"
        label.isHidden = true
        label.alpha = 0
        return label
    }()
    
    private let boardGameView: UIView = {
        let boardView = UIView()
        boardView.backgroundColor = .none
        return boardView
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(font: .boldSystemFont(ofSize: 20), textColor: .systemRed)
        return label
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(font: .boldSystemFont(ofSize: 20), textColor: .systemRed)
        label.textAlignment = .right
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(font: .boldSystemFont(ofSize: 20), textColor: .systemRed)
        label.textAlignment = .right
        return label
    }()
    
    // MARK: Constraints
    
    private func makeConstraints() {
        homeButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        
        infoButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        
        startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(340)
            make.height.equalTo(104)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameTextField.snp.bottom).inset(3)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        
        boardGameView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(startButton.snp.bottom).offset(0)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(0)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(5)
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.leading.equalTo(homeButton.snp.trailing)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(30)
            make.width.equalTo(100)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.trailing.equalTo(infoButton.snp.leading).inset(-15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(30)
            make.width.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(30)
            make.width.equalTo(100)
        }
        
        alert.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: Actions
    
    private func bind() {
        homeButton.addAction(UIAction(handler: { [weak self] _ in
            playSound(sound: "click", type: "wav")
            self?.dismiss(animated: true, completion: nil)
            MusicPlayer.shared.stopBackgroundMusic()
        }), for: .touchUpInside)
        
        infoButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            playSound(sound: "click", type: "wav")
            showAlertWith(alertType: .infoAlert)
        }), for: .touchUpInside)
        
        startButton.addAction(UIAction(title: "", handler: { [weak self] _ in
            // Checking for empty nameTextField
            self?.checkNameField()
            guard (self?.errorLabel.isHidden) == true else { return }
            
            // Hide the keyboard if it is open
            self?.nameTextField.resignFirstResponder()
            
            // Game board locking for the animation time
            self?.boardGameView.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self?.boardGameView.isUserInteractionEnabled = true
            }
            
            playSound(sound: "startGame", type: "mp3")
            self?.nameLabel.text = self?.nameTextField.text
            
            UIView.animate(withDuration: 0.5, animations: {
                self?.startButton.snp.remakeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.top.equalTo(self?.view.safeAreaLayoutGuide.snp.top ?? 0).inset(20)
                    make.width.equalTo(170)
                    make.height.equalTo(52)
                }
                
                self?.nameTextField.snp.remakeConstraints { make in
                    make.centerX.equalToSuperview().offset(-1500)
                    make.top.equalTo(self?.view.safeAreaLayoutGuide.snp.top ?? 0).inset(20)
                }
                
                self?.nameLabel.snp.remakeConstraints { make in
                    make.trailing.equalTo(self?.timerLabel.snp.leading ?? 0).inset(0)
                    make.top.equalTo(self?.view.safeAreaLayoutGuide.snp.top ?? 0).inset(30)
                    make.width.equalTo(150)
                }
                
                self?.view.layoutIfNeeded()
            }, completion: { _ in
            })
            
            guard let newGame = self?.getNewGame() else { return }
            self?.game = newGame
            guard let cards = self?.getCardsBy(modelData: newGame.cards) else { return }
            self?.placeCardsOnBoard(cards)
        }), for: .touchUpInside)
    }
    
    // MARK: Setup View
    
    private func setupView() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "CardGameBackground")!)
        view.addSubview(homeButton)
        view.addSubview(infoButton)
        view.addSubview(boardGameView)
        view.addSubview(nameLabel)
        view.addSubview(startButton)
        view.addSubview(nameTextField)
        view.addSubview(errorLabel)
        view.addSubview(scoreLabel)
        view.addSubview(timerLabel)
        view.addSubview(alert)
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        setupView()
        makeConstraints()
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
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
    
    // MARK: Preparing new game
    
    private func getNewGame() -> CardGame {
        let game = CardGame()
        gameScore = 0
        game.cardsCount = cardsPairsCounts
        game.generateCards()
        return game
    }
    
    // MARK: Card array generation
    
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
                            self.showAlertWith(alertType: .scoreAlert, score: self.gameScore)
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
                            UserDefaults.standard.set(self.userName, forKey: "userName")
                            UserDefaults.standard.set(self.totalTime, forKey: "totalTime")
                            UserDefaults.standard.synchronize()
                            
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
    
    // MARK: Place cards on board
    
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
        
        // MARK: Methods
        
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
    
    // Preparing alert
    private func showAlertWith(alertType: alertTypesEnum, score: Int? = 0) {
        alert.showAlert()
        switch alertType {
        case .scoreAlert:
            let scoreString = String(score ?? 0)
            alert.alertContent?("Игра окончена",
                                "Вы набрали \(scoreString) очков \nЗа \(totalTime) секунд ",
                                "CardsScoreAlertButton")
            
            countTimer?.invalidate()
            playSound(sound: "win", type: "mp3")
            
        case .infoAlert:
            alert.alertContent?("Правила игры",
                                "Найдите пары карточек", "CardsInfoAlertButton")
            
            MusicPlayer.shared.startBackgroundMusic(backgroundMusicFileName: "info")
        }
    }
    
    // Starting game timer
    func startTimer() {
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
