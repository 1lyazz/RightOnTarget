//  RightOnTargetVC.swift
//  Right on target
//  Created by Ilya Zablotski

import Feedbacks
import SnapKit
import UIKit

class SliderGameVC: UIViewController {
    private var game: SliderGame!
    private let alert = CustomAlert(gameType: .sliderGame)
    private let rounds: Int = 5

    // MARK: Scene Elements
    
    @IBOutlet var slider: UISlider!
    
    private let checkButton: UIButton = {
        let button = UIButton()
        button.setAppButtonStyle(backgroundImage: "SliderCheckButton", title: "ПРОВЕРИТЬ", titleColor: .systemYellow)
        return button
    }()
    
    private let homeButton: UIButton = {
        let button = UIButton()
        button.setAppButtonStyle(backgroundImage: "SliderHomeButton")
        return button
    }()
    
    private let infoButton: UIButton = {
        let button = UIButton()
        button.setAppButtonStyle(backgroundImage: "SliderInfoButton")
        return button
    }()
    
    private let secretNumberLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(font: .boldSystemFont(ofSize: 26), textColor: .systemPurple)
        return label
    }()
    
    private let secretNumberLabel2: UILabel = {
        let label = UILabel()
        label.setLabelStyle(font: .systemFont(ofSize: 25), textColor: .systemPink)
        return label
    }()
    
    private let roundLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(font: .boldSystemFont(ofSize: 20), textColor: .systemPink)
        return label
    }()
    
    // MARK: Constraints
    
    private func makeConstraints() {
        checkButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(slider.snp.bottom).offset(30)
            make.height.equalTo(52)
            make.width.equalTo(200)
        }
        
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
        
        secretNumberLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(slider.snp.bottom).offset(109)
        }
        
        secretNumberLabel2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(slider.snp.bottom).offset(109)
        }
        
        roundLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(35)
            make.width.equalTo(100)
        }
        
        alert.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: Actions
    
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
            showAlertWith(alertType: .infoAlert)
        }), for: .touchUpInside)
    }

    // MARK: Setup View
    
    private func setupView() {
        view.addSubview(checkButton)
        view.addSubview(homeButton)
        view.addSubview(infoButton)
        view.addSubview(secretNumberLabel)
        view.addSubview(secretNumberLabel2)
        view.addSubview(roundLabel)
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
        // Create instance of entity "Game"
        game = SliderGame(startValue: 1, endValue: 50, rounds: rounds)
        // Update label with actual(new random) secret number
        updateLabelWithSecretNumber(newText: String(game.currentSecretValue))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MusicPlayer.shared.startBackgroundMusic(backgroundMusicFileName: "game")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        roundLabel.text = "РАУНД \(game.currentRound)"
    }
    
    // MARK: - Interaction View - Model
    
    // Checking number of user selected
    private func checkNumber() {
        // Calculating points per round and add to score anount
        game.calculateScore(with: Int(slider.value))
        // Checking game ended
        if game.isGameEnded {
            showAlertWith(alertType: .scoreAlert, score: game.score)
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
    
    private func showAlertWith(alertType: alertTypesEnum, score: Int? = 0) {
        alert.showAlert()
        switch alertType {
        case .scoreAlert:
            let scoreString = String(score ?? 0)
            alert.alertContent?("Игра окончена",
                                "Вы заработали \(scoreString) из \(rounds * 50) очков",
                                "SliderScoreAlertButton")
            
            score ?? 0 >= 200 ? playSound(sound: "win", type: "mp3") :
                MusicPlayer.shared.startBackgroundMusic(backgroundMusicFileName: "gameOver")
        case .infoAlert:
            alert.alertContent?("Правила игры",
                                "В игре \(rounds) раундов. \n Необходимо угадать \n расположение числа на слайдере.",
                                "SliderInfoAlertButton")
            
            MusicPlayer.shared.startBackgroundMusic(backgroundMusicFileName: "info")
        }
    }
}
