//  CardGameView.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import SnapKit
import UIKit

class CardGameView: UIView {
    
    var countTimer: Timer?
    var totalTime: Int = 0
    
    // MARK: - UI Elements
    
    private let alert = CustomAlert(gameType: .cardGame)
    
    let homeButton: UIButton = {
        let button = UIButton()
        button.setAppButtonStyle(backgroundImage: "CardsHomeButton")
        return button
    }()
    
    let infoButton: UIButton = {
        let button = UIButton()
        button.setAppButtonStyle(backgroundImage: "CardsInfoButton")
        return button
    }()
    
    let startButton: UIButton = {
        let button = UIButton()
        button.setAppButtonStyle(backgroundImage: "CardsStratButton")
        return button
    }()
    
    let nameTextField: UITextField = {
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
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(font: .systemFont(ofSize: 18), textColor: .red)
        label.text = "Please enter your name"
        label.isHidden = true
        label.alpha = 0
        return label
    }()
    
    let boardGameView: UIView = {
        let boardView = UIView()
        boardView.backgroundColor = .none
        return boardView
    }()
    
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(font: .boldSystemFont(ofSize: 20), textColor: .systemRed)
        return label
    }()
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(font: .boldSystemFont(ofSize: 20), textColor: .systemRed)
        label.textAlignment = .right
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(font: .boldSystemFont(ofSize: 20), textColor: .systemRed)
        label.textAlignment = .right
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
    
    // Preparing alert
    func showAlertWith(alertType: alertTypesEnum, score: Int? = 0, totalTime: Int? = 0) {
        alert.showAlert()
        switch alertType {
        case .scoreAlert:
            let scoreString = String(score ?? 0)
            let totalTime = String(totalTime ?? 0)
            alert.alertContent?("Игра окончена",
                                "Вы набрали \(scoreString) очков \nЗа \(totalTime) секунд ",
                                "CardsScoreAlertButton")
            
            playSound(sound: "win", type: "mp3")
            
        case .infoAlert:
            alert.alertContent?("Правила игры",
                                "Найдите пары карточек", "CardsInfoAlertButton")
            
            MusicPlayer.shared.startBackgroundMusic(backgroundMusicFileName: "info")
        }
    }
    
    func animateStartButton() {
        UIView.animate(withDuration: 0.5, animations: {
            self.startButton.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(20)
                make.width.equalTo(170)
                make.height.equalTo(52)
            }
            
            self.nameTextField.snp.remakeConstraints { make in
                make.centerX.equalToSuperview().offset(-1500)
                make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(20)
            }
            
            self.nameLabel.snp.remakeConstraints { make in
                make.trailing.equalTo(self.timerLabel.snp.leading)
                make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(30)
                make.width.equalTo(150)
            }
            
            self.layoutIfNeeded()
        })
    }
}

// MARK: - Private Methods

private extension CardGameView {
    private func setupView() {
        [homeButton, infoButton, boardGameView, nameLabel, startButton,
         nameTextField, errorLabel, scoreLabel, timerLabel, alert].forEach(addSubview)
    }

    private func setupViewConstraints() {
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
        
        startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(340)
            make.height.equalTo(104)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(20)
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
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(0)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(5)
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.leading.equalTo(homeButton.snp.trailing)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(30)
            make.width.equalTo(100)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.trailing.equalTo(infoButton.snp.leading).inset(-15)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(30)
            make.width.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(30)
            make.width.equalTo(100)
        }
        
        alert.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
