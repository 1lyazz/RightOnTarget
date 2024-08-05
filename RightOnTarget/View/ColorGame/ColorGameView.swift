//  ColorGameView.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import SnapKit
import UIKit

final class ColorGameView: UIView {
    
    // MARK: - UI Elements
    
    let colorButtons = ColorButtonsView()
    let alert = CustomAlert(gameType: .colorGame)
    
    private let hexGameLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "HexGameLogo")
        return imageView
    }()
    
    let hexSecretColor: UILabel = {
        let label = UILabel()
        label.setLabelStyle(font: .boldSystemFont(ofSize: 30), textColor: .systemMint)
        return label
    }()
    
    let roundLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(font: .boldSystemFont(ofSize: 20), textColor: .systemMint)
        return label
    }()
    
    let homeButton: UIButton = {
        let button = UIButton()
        button.setAppButtonStyle(backgroundImage: "ColorHomeButton")
        return button
    }()
    
    let infoButton: UIButton = {
        let button = UIButton()
        button.setAppButtonStyle(backgroundImage: "ColorInfoButton")
        return button
    }()
    
    // MARK: - Initialization

    init() {
        super.init(frame: .zero)
        setupView()
        setupViewConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showAlertWith(alertType: alertTypesEnum, score: Int? = 0, rounds: Int? = 6) {
        alert.showAlert()
        let rounds = String(rounds ?? 6)
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

// MARK: - Private Methods

private extension ColorGameView {
    private func setupView() {
        [hexGameLogo, hexSecretColor, roundLabel, infoButton, colorButtons, homeButton, infoButton, alert].forEach(addSubview)
    }

    private func setupViewConstraints() {
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
            make.top.equalTo(colorButtons.colorButton5.snp.bottom).offset(10)
            make.width.equalTo(100)
        }
        
        homeButton.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).inset(20)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(20)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        
        infoButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).inset(20)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(20)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        
        alert.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        colorButtons.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
