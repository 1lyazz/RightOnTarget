//  CustomAlert.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import SnapKit
import UIKit

final class CustomAlert: UIView {
    
    // MARK: - Alert Elements
    
    var alertContent: ((String, String, String) -> Void)?
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.6
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .none
        return view
    }()
    
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .none
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(font: .boldSystemFont(ofSize: 40), textColor: .systemYellow)
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.setLabelStyle(font: .boldSystemFont(ofSize: 20), textColor: .white, numberOfLines: 3)
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.dismissAlert()
            MusicPlayer.shared.startBackgroundMusic(backgroundMusicFileName: "game")
        }), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    init(gameType: gameTypeEnum) {
        super.init(frame: .zero)
        setupView()
        makeConstraints()
        dismissAlert()
        setupAlertType(gameType: gameType)
        setAlertContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Constraints
    
    private func makeConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        alertView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-450)
            make.width.equalTo(400)
            make.height.equalTo(300)
        }
        
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalTo(alertView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(backgroundImage)
            make.centerY.equalTo(backgroundImage).offset(40)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.centerX.equalTo(backgroundImage)
            make.centerY.equalTo(backgroundImage).offset(100)
        }
        
        closeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(alertView.snp.bottom).offset(30)
            make.width.equalTo(150)
            make.height.equalTo(55)
        }
    }
    
    // MARK: - Setup View
    
    private func setupView() {
        [backgroundView, alertView, closeButton].forEach(self.addSubview)
        [backgroundImage, titleLabel, messageLabel].forEach(alertView.addSubview)
    }
    
    // MARK: - Alert Methods
    
    private func setAlertContent() {
        alertContent = { [weak self] title, message, button in
            self?.titleLabel.text = title
            self?.messageLabel.text = message
            self?.closeButton.setBackgroundImage(UIImage(named: button), for: .normal)
        }
    }
    
    private func setupAlertType(gameType: gameTypeEnum) {
        switch gameType {
        case .colorGame:
            backgroundImage.image = UIImage(named: "ColorAlert")
            titleLabel.textColor = .systemMint
        case .sliderGame:
            backgroundImage.image = UIImage(named: "SliderAlert")
            titleLabel.textColor = .systemYellow
        case .cardGame:
            backgroundImage.image = UIImage(named: "CardsAlert")
            titleLabel.textColor = .systemRed
            messageLabel.textColor = .systemPink
        }
    }
    
    func showAlert() {
        MusicPlayer.shared.stopBackgroundMusic()
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        }, completion: { [weak self] done in
            if done {
                self?.alertView.snp.remakeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.centerY.equalToSuperview().offset(-30)
                    make.width.equalTo(400)
                    make.height.equalTo(300)
                }
                
                UIView.animate(withDuration: 0.3, animations: {
                    self?.layoutIfNeeded()
                })
            }
        })
    }
    
    func dismissAlert() {
        alertView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(450)
            make.width.equalTo(400)
            make.height.equalTo(300)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
            self.alpha = 0
        })
        
        MusicPlayer.shared.stopBackgroundMusic()
    }
}

enum gameTypeEnum {
    case colorGame
    case sliderGame
    case cardGame
}

enum alertTypesEnum {
    case scoreAlert
    case infoAlert
}
