//  SliderGameView.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import SnapKit
import UIKit

final class SliderGameView: UIView {
    
    // MARK: - UI Elements
    
    let alert = CustomAlert(gameType: .sliderGame)
    
    let checkButton: UIButton = {
        let button = UIButton()
        button.setAppButtonStyle(backgroundImage: "SliderCheckButton", title: "ПРОВЕРИТЬ", titleColor: .systemYellow)
        return button
    }()
    
    let homeButton: UIButton = {
        let button = UIButton()
        button.setAppButtonStyle(backgroundImage: "SliderHomeButton")
        return button
    }()
    
    let infoButton: UIButton = {
        let button = UIButton()
        button.setAppButtonStyle(backgroundImage: "SliderInfoButton")
        return button
    }()
    
    let secretNumberLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(font: .boldSystemFont(ofSize: 26), textColor: .systemPurple)
        return label
    }()
    
    let secretNumberLabel2: UILabel = {
        let label = UILabel()
        label.setLabelStyle(font: .systemFont(ofSize: 25), textColor: .systemPink)
        return label
    }()
    
    let roundLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(font: .boldSystemFont(ofSize: 20), textColor: .systemPink)
        return label
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
    
    func showAlertWith(alertType: alertTypesEnum, score: Int? = 0, rounds: Int? = 5) {
        alert.showAlert()
        let maxScore = Int((rounds ?? 5) * 50)
        let rounds = String(rounds ?? 5)
        switch alertType {
        case .scoreAlert:
            let scoreString = String(score ?? 0)
            alert.alertContent?("Игра окончена",
                                "Вы заработали \(scoreString) из \(maxScore) очков",
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

// MARK: - Private Methods

private extension SliderGameView {
    private func setupView() {
        [checkButton, homeButton, infoButton, secretNumberLabel, secretNumberLabel2, roundLabel].forEach(addSubview)
    }

    private func setupViewConstraints() {
        checkButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(90)
            make.height.equalTo(52)
            make.width.equalTo(200)
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
        
        secretNumberLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(checkButton.snp.bottom).offset(10)
        }
        
        secretNumberLabel2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(checkButton.snp.bottom).offset(10)
        }
        
        roundLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(35)
            make.width.equalTo(100)
        }
        
        alert.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
