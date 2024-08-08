//  Game1VC.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import Feedbacks
import SnapKit
import UIKit

final class ColorGameVC: UIViewController {
    
    private var game: ColorGame!
    private let rounds: Int = 6
    private var colorButtons = [UIButton]()
    private var secretColorsArray: [UIColor] = [.red, .green, .blue, .white, .black, .yellow]
    
    // MARK: Scene Elements
    
    private let colorGameView = ColorGameView()
    private lazy var homeButton = colorGameView.homeButton
    private lazy var infoButton = colorGameView.infoButton
    private lazy var roundLabel = colorGameView.roundLabel
    private lazy var hexSecretColor = colorGameView.hexSecretColor
    private lazy var colorButton1 = colorGameView.colorButtons.colorButton1
    private lazy var colorButton2 = colorGameView.colorButtons.colorButton2
    private lazy var colorButton3 = colorGameView.colorButtons.colorButton3
    private lazy var colorButton4 = colorGameView.colorButtons.colorButton4
    private lazy var colorButton5 = colorGameView.colorButtons.colorButton5
    private lazy var colorButton6 = colorGameView.colorButtons.colorButton6
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
        setupView()
        makeConstraints()
        bind()
        setupGame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MusicPlayer.shared.startBackgroundMusic(backgroundMusicFileName: "game")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        roundLabel.text = "ROUND \(game.currentRound)"
    }
}

// MARK: Private Methods

private extension ColorGameVC {
    private func setupStyle() {
        Constants.colorGameGradient.frame = view.bounds
        view.layer.insertSublayer(Constants.colorGameGradient, at: 0)
    }
    
    private func setupGame() {
        colorButtons = [colorButton1, colorButton2, colorButton3, colorButton4, colorButton5, colorButton6]
        shuffleButtonColors()
        game = ColorGame(secretColorsArray: secretColorsArray, rounds: rounds)
        updateHexSecretColor(newColorHex: game.getSecretColorHex())
    }
    
    // MARK: Setup View
    
    private func setupView() {
        view.addSubview(colorGameView)
    }
    
    // MARK: Constraints
    
    private func makeConstraints() {
        colorGameView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: Bindings
    
    private func bind() {
        homeButton.addAction(UIAction(handler: { [weak self] _ in
            playSound(sound: "click", type: "wav")
            self?.dismiss(animated: true, completion: nil)
            MusicPlayer.shared.stopBackgroundMusic()
        }), for: .touchUpInside)

        infoButton.addAction(UIAction(handler: { [weak self] _ in
            playSound(sound: "click", type: "wav")
            self?.colorGameView.showAlertWith(alertType: .infoAlert)
        }), for: .touchUpInside)

        let colorButtons: [UIButton] = [colorButton1, colorButton2, colorButton3, colorButton4, colorButton5, colorButton6]
        colorButtons.forEach { button in
            button.addAction(UIAction(handler: { [weak self] _ in
                if let color = button.backgroundColor {
                    self?.checkColor(with: color)
                }
            }), for: .touchUpInside)
        }
    }
    
    // MARK: - Interaction View - Model
    
    // Checking color of user selected
    private func checkColor(with buttonColor: UIColor) {
        // Calculating points per round and add to score anount
        game.calculateScore(with: buttonColor)
        if game.isGameEnded {
            colorGameView.showAlertWith(alertType: .scoreAlert, score: game.score, rounds: rounds)
            shuffleButtonColors()
            game.restartGame()
        } else {
            shuffleButtonColors()
            game.startNewRound()
        }
        updateHexSecretColor(newColorHex: game.getSecretColorHex())
    }
    
    // MARK: - Game methods
    
    private func updateHexSecretColor(newColorHex: String) {
        hexSecretColor.text = newColorHex
    }
    
    private func shuffleButtonColors() {
        secretColorsArray.shuffle()
        for (index, button) in colorButtons.enumerated() {
            button.backgroundColor = secretColorsArray[index]
        }
    }
}
