//  Game1VC.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import Feedbacks
import SnapKit
import UIKit

class ColorGameVC: UIViewController {
    private var game: ColorGame!
    private let alert = CustomAlert(gameType: .colorGame)
    private let rounds: Int = 6
    private var colorButtons = [UIButton]()
    private var secretColorsArray: [UIColor] = [.red, .green, .blue, .white, .black, .yellow]
    
    // MARK: Scene Elements
    
    private let hexGameLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "HexGameLogo")
        return imageView
    }()
    
    private let hexSecretColor: UILabel = {
        let label = UILabel()
        label.setLabelStyle(font: .boldSystemFont(ofSize: 30), textColor: .systemMint)
        return label
    }()
    
    private let roundLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(font: .boldSystemFont(ofSize: 20), textColor: .systemMint)
        return label
    }()
    
    private let homeButton: UIButton = {
        let button = UIButton()
        button.setAppButtonStyle(backgroundImage: "ColorHomeButton")
        return button
    }()
    
    private let infoButton: UIButton = {
        let button = UIButton()
        button.setAppButtonStyle(backgroundImage: "ColorInfoButton")
        return button
    }()
    
    private let colorButton1: UIButton = {
        let button = UIButton()
        button.setColorButtonShape()
        return button
    }()
    
    private let colorButton2: UIButton = {
        let button = UIButton()
        button.setColorButtonShape()
        return button
    }()
    
    private let colorButton3: UIButton = {
        let button = UIButton()
        button.setColorButtonShape()
        return button
    }()
    
    private let colorButton4: UIButton = {
        let button = UIButton()
        button.setColorButtonShape()
        return button
    }()
    
    private let colorButton5: UIButton = {
        let button = UIButton()
        button.setColorButtonShape()
        return button
    }()
    
    private let colorButton6: UIButton = {
        let button = UIButton()
        button.setColorButtonShape()
        return button
    }()
        
    // MARK: Constraints
    
    private func makeConstraints() {
        hexGameLogo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-90)
            make.width.equalTo(350)
            make.height.equalTo(250)
        }
        
        hexSecretColor.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(hexGameLogo.snp.bottom).offset(-50)
        }
        
        roundLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(colorButton5.snp.bottom).offset(10)
            make.width.equalTo(100)
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
    
        colorButton1.snp.makeConstraints { make in
            make.trailing.equalTo(colorButton2.snp.trailing).inset(170)
            make.top.equalTo(hexGameLogo.snp.bottom).offset(0)
        }
        
        colorButton2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(hexGameLogo.snp.bottom).offset(0)
        }
        
        colorButton3.snp.makeConstraints { make in
            make.leading.equalTo(colorButton2.snp.leading).inset(170)
            make.top.equalTo(hexGameLogo.snp.bottom).offset(0)
        }
        
        colorButton4.snp.makeConstraints { make in
            make.trailing.equalTo(colorButton5.snp.trailing).inset(170)
            make.top.equalTo(colorButton2.snp.bottom).offset(20)
        }
        
        colorButton5.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(colorButton2.snp.bottom).offset(20)
        }
        
        colorButton6.snp.makeConstraints { make in
            make.leading.equalTo(colorButton5.snp.leading).inset(170)
            make.top.equalTo(colorButton2.snp.bottom).offset(20)
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
        
        colorButton1.addAction(UIAction(handler: { [weak self] _ in
            self?.checkColor(with: self?.colorButton1.backgroundColor ?? UIColor())
        }), for: .touchUpInside)
        
        colorButton2.addAction(UIAction(handler: { [weak self] _ in
            self?.checkColor(with: self?.colorButton2.backgroundColor ?? UIColor())
        }), for: .touchUpInside)
        
        colorButton3.addAction(UIAction(handler: { [weak self] _ in
            self?.checkColor(with: self?.colorButton3.backgroundColor ?? UIColor())
        }), for: .touchUpInside)
        
        colorButton4.addAction(UIAction(handler: { [weak self] _ in
            self?.checkColor(with: self?.colorButton4.backgroundColor ?? UIColor())
        }), for: .touchUpInside)
        
        colorButton5.addAction(UIAction(handler: { [weak self] _ in
            self?.checkColor(with: self?.colorButton5.backgroundColor ?? UIColor())
        }), for: .touchUpInside)
        
        colorButton6.addAction(UIAction(handler: { [weak self] _ in
            self?.checkColor(with: self?.colorButton6.backgroundColor ?? UIColor())
        }), for: .touchUpInside)
    }
    
    // MARK: Setup View
    
    private func setupView() {
        view.addSubview(hexGameLogo)
        view.addSubview(hexSecretColor)
        view.addSubview(roundLabel)
        view.addSubview(homeButton)
        view.addSubview(infoButton)
        view.addSubview(colorButton1)
        view.addSubview(colorButton2)
        view.addSubview(colorButton3)
        view.addSubview(colorButton4)
        view.addSubview(colorButton5)
        view.addSubview(colorButton6)
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
        colorButtons = [colorButton1, colorButton2, colorButton3, colorButton4, colorButton5, colorButton6]
        shuffleButtonColors()
        game = ColorGame(secretColorsArray: secretColorsArray, rounds: rounds)
        updateHexSecretColor(newColorHex: game.getSecretColorHex())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MusicPlayer.shared.startBackgroundMusic(backgroundMusicFileName: "game")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Constants.colorGameGradient.frame = view.bounds
        view.layer.insertSublayer(Constants.colorGameGradient, at: 0)
        roundLabel.text = "ROUND \(game.currentRound)"
    }
    
    // MARK: - Interaction View - Model
    
    // Checking color of user selected
    private func checkColor(with buttonColor: UIColor) {
        // Calculating points per round and add to score anount
        game.calculateScore(with: buttonColor)
        if game.isGameEnded {
            showAlertWith(alertType: .scoreAlert, score: game.score)
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
    
    private func showAlertWith(alertType: alertTypesEnum, score: Int? = 0) {
        alert.showAlert()
        switch alertType {
        case .scoreAlert:
            let scoreString = String(score ?? 0)
            alert.alertContent?("Игра окончена",
                                "Вы заработали \(scoreString) из \(rounds) очков",
                                "ColorScoreAlertButton")
            
            score == 5 || score == 6 ? playSound(sound: "win", type: "mp3") :
            MusicPlayer.shared.startBackgroundMusic(backgroundMusicFileName: "gameOver")

        case .infoAlert:
            alert.alertContent?("Правила игры",
                                "В игре \(rounds) раундов. \n Необходимо угадать цвет по HEX-коду.",
                                "ColorInfoAlertButton")
            
            MusicPlayer.shared.startBackgroundMusic(backgroundMusicFileName: "info")
        }
    }
}

