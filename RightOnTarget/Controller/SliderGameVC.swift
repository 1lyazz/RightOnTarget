//  RightOnTargetVC.swift
//  Right on target
//  Created by Ilya Zablotski

import Feedbacks
import SnapKit
import UIKit

final class SliderGameVC: UIViewController {
    
    private var game: SliderGame!
    private let rounds: Int = 5
    
    // MARK: Scene Elements
    
    @IBOutlet var slider: UISlider!
    
    private let sliderGameView = SliderGameView()
    private lazy var checkButton = sliderGameView.checkButton
    private lazy var homeButton = sliderGameView.homeButton
    private lazy var infoButton = sliderGameView.infoButton
    private lazy var roundLabel = sliderGameView.roundLabel
    private lazy var secretNumberLabel = sliderGameView.secretNumberLabel
    private lazy var secretNumberLabel2 = sliderGameView.secretNumberLabel
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        roundLabel.text = "РАУНД \(game.currentRound)"
    }
}

private extension SliderGameVC {
    private func setupGame() {
        // Create instance of entity "Game"
        game = SliderGame(startValue: 1, endValue: 50, rounds: rounds)
        // Update label with actual(new random) secret number
        updateLabelWithSecretNumber(newText: String(game.currentSecretValue))
    }
    
    // MARK: Setup View
    
    private func setupView() {
        view.addSubview(sliderGameView)
    }
    
    // MARK: Constraints
    
    private func makeConstraints() {
        sliderGameView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: Bindings
    
    private func bind() {
        checkButton.addAction(UIAction(handler: { [weak self] _ in
            self?.checkButton.fck.hapticSelection()
            self?.checkNumber()
        }), for: .touchUpInside)
        
        homeButton.addAction(UIAction(handler: { [weak self] _ in
            playSound(sound: "click", type: "wav")
            self?.dismiss(animated: true, completion: nil)
            MusicPlayer.shared.stopBackgroundMusic()
        }), for: .touchUpInside)
        
        infoButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            playSound(sound: "click", type: "wav")
            sliderGameView.showAlertWith(alertType: .infoAlert)
        }), for: .touchUpInside)
    }
    
    // MARK: - Interaction View - Model
    
    // Checking number of user selected
    private func checkNumber() {
        // Calculating points per round and add to score anount
        game.calculateScore(with: Int(slider.value))
        // Checking game ended
        if game.isGameEnded {
            sliderGameView.showAlertWith(alertType: .scoreAlert, score: game.score, rounds: rounds)
            // Start new game
            game.restartGame()
        } else {
            game.startNewRound()
        }
        // Update label with actual(new random) secret number
        updateLabelWithSecretNumber(newText: String(game.currentSecretValue))
    }
    
    // MARK: - Game methods

    // Method for update label with actual(new random) secret number
    private func updateLabelWithSecretNumber(newText: String) {
        secretNumberLabel.text = newText
        secretNumberLabel2.text = newText
    }
}
