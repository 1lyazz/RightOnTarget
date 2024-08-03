//  HomeVC.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import Feedbacks
import SnapKit
import UIKit

class HomeVC: UIViewController {
    enum Constants {
        static let appDarkGray = UIColor(red: 37/255, green: 37/255, blue: 37/255, alpha: 1)
    }
    
    // MARK: Scene Elements
    
    private let appLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppLogo")
        return imageView
    }()
    
    private let appLogoLight: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppLogoLight")
        return imageView
    }()
    
    private let dartBoard: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "DartBoard")
        return imageView
    }()
    
    private let rightCatBottom: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "RightCat")
        return imageView
    }()
    
    private let rightCatTop: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "RightCat")
        return imageView
    }()
    
    private let leftCatBottom: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LeftCat")
        return imageView
    }()
    
    private let leftCatVers: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LeftCat")
        return imageView
    }()
    
    private let leftCatTop: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LeftCat")
        return imageView
    }()
    
    private let gameButton1: UIButton = {
        let button = UIButton()
        button.setAppButtonStyle(backgroundImage: "WhiteButton", title: "HEX", titleColor: .darkText)
        return button
    }()
    
    private let gameButton2: UIButton = {
        let button = UIButton()
        button.setAppButtonStyle(backgroundImage: "GrayButton", title: "SLIDER", titleColor: .white)
        return button
    }()
    
    private let gameButton3: UIButton = {
        let button = UIButton()
        button.setAppButtonStyle(backgroundImage: "WhiteButton", title: "CARDS", titleColor: .darkText)
        return button
    }()
    
    private let gameInfoButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "GameInfoButton"), for: .normal)
        return button
    }()
    
    private let leaderboardButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "LeaderboardButton"), for: .normal)
        return button
    }()
    
    // MARK: Constraints
    
    private func makeConstraints() {
        appLogo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-70)
            make.width.equalTo(350)
            make.height.equalTo(250)
        }

        appLogoLight.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-70)
            make.width.equalTo(400)
            make.height.equalTo(300)
        }

        dartBoard.snp.makeConstraints { make in
            make.bottom.equalTo(gameButton2.snp.top).offset(-20)
            make.leading.equalTo(appLogo.snp.trailing).offset(80)
            make.width.equalTo(130)
            make.height.equalTo(130)
        }
        
        rightCatBottom.snp.makeConstraints { make in
            make.bottom.equalTo(gameButton2.snp.top).offset(-150)
            make.leading.equalTo(appLogo.snp.trailing).offset(80)
            make.width.equalTo(40)
            make.height.equalTo(36)
        }
        
        rightCatTop.snp.makeConstraints { make in
            make.bottom.equalTo(gameButton2.snp.top).offset(-170)
            make.leading.equalTo(appLogo.snp.trailing).offset(160)
            make.width.equalTo(40)
            make.height.equalTo(36)
        }
        
        leftCatBottom.snp.makeConstraints { make in
            make.bottom.equalTo(gameButton2.snp.top).offset(-60)
            make.trailing.equalTo(appLogo.snp.leading).offset(-130)
            make.width.equalTo(40)
            make.height.equalTo(36)
        }
        
        leftCatVers.snp.makeConstraints { make in
            make.bottom.equalTo(gameButton2.snp.top).offset(-140)
            make.trailing.equalTo(appLogo.snp.leading).offset(-40)
            make.width.equalTo(40)
            make.height.equalTo(36)
        }
        
        leftCatTop.snp.makeConstraints { make in
            make.bottom.equalTo(gameButton2.snp.top).offset(-200)
            make.trailing.equalTo(appLogo.snp.leading).offset(-110)
            make.width.equalTo(40)
            make.height.equalTo(36)
        }
        
        gameButton1.snp.makeConstraints { make in
            make.top.equalTo(appLogo.snp.bottom).offset(30)
            make.trailing.equalTo(gameButton2.snp.trailing).inset(250)
            make.height.equalTo(52)
            make.width.equalTo(200)
        }
        
        gameButton2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(appLogo.snp.bottom).offset(30)
            make.height.equalTo(52)
            make.width.equalTo(200)
        }
        
        gameButton3.snp.makeConstraints { make in
            make.top.equalTo(appLogo.snp.bottom).offset(30)
            make.leading.equalTo(gameButton2.snp.leading).inset(250)
            make.height.equalTo(52)
            make.width.equalTo(200)
        }
        
        gameInfoButton.snp.makeConstraints { make in
            make.bottom.equalTo(gameButton2.snp.top).offset(-100)
            make.trailing.equalTo(appLogo.snp.leading).offset(-100)
            make.width.equalTo(90)
            make.height.equalTo(90)
        }
        
        leaderboardButton.snp.makeConstraints { make in
            make.bottom.equalTo(gameButton2.snp.top).offset(-180)
            make.leading.equalTo(appLogo.snp.trailing).offset(70)
            make.width.equalTo(90)
            make.height.equalTo(90)
        }
    }

    // MARK: Actions
    
    private func bind() {
        gameButton1.addAction(UIAction(handler: { [weak self] _ in
            self?.gameButton1.fck.hapticSelection()
            playSound(sound: "click", type: "wav")
            let colorGameVC = ColorGameVC()
            self?.presentVC(colorGameVC)
        }), for: .touchUpInside)
        
        gameButton2.addAction(UIAction(handler: { [weak self] _ in
            self?.gameButton2.fck.hapticSelection()
            playSound(sound: "click", type: "wav")
            let sliderGameVC: SliderGameVC = {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(identifier: "SliderGameVC")
                return viewController as! SliderGameVC
            }()
            self?.presentVC(sliderGameVC)
        }), for: .touchUpInside)
        
        gameButton3.addAction(UIAction(handler: { [weak self] _ in
            self?.gameButton3.fck.hapticSelection()
            playSound(sound: "click", type: "wav")
            let cardsGameVC = CardsGameVC()
            self?.presentVC(cardsGameVC)
        }), for: .touchUpInside)
        
        gameInfoButton.addAction(UIAction(handler: { [weak self] _ in
            self?.gameInfoButton.fck.hapticSelection()
            MusicPlayer.shared.stopBackgroundMusic()
            playSound(sound: "click", type: "wav")
            let gameInfoVC: GameInfoVC = {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(identifier: "GameInfoVC")
                return viewController as! GameInfoVC
            }()
            self?.presentVC(gameInfoVC)
        }), for: .touchUpInside)
        
        leaderboardButton.addAction(UIAction(handler: { [weak self] _ in
            self?.leaderboardButton.fck.hapticSelection()
            MusicPlayer.shared.stopBackgroundMusic()
            playSound(sound: "click", type: "wav")
            let leaderboardVC: LeaderboardVC = {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(identifier: "LeaderboardVC")
                return viewController as! LeaderboardVC
            }()
            self?.presentVC(leaderboardVC)
        }), for: .touchUpInside)
    }

    // MARK: Setup View
    
    private func setupView() {
        view.addSubview(appLogoLight)
        view.addSubview(appLogo)
        view.addSubview(dartBoard)
        view.addSubview(rightCatBottom)
        view.addSubview(rightCatTop)
        view.addSubview(leftCatBottom)
        view.addSubview(leftCatVers)
        view.addSubview(leftCatTop)
        view.addSubview(gameButton1)
        view.addSubview(gameButton2)
        view.addSubview(gameButton3)
        view.addSubview(gameInfoButton)
        view.addSubview(leaderboardButton)
    }

    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = Constants.appDarkGray
        setupView()
        makeConstraints()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MusicPlayer.shared.startBackgroundMusic(backgroundMusicFileName: "info")
        startAnimation()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        MusicPlayer.shared.stopBackgroundMusic()
    }

    private func startAnimation() {
        UIView.animate(withDuration: 3, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.appLogo.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.appLogoLight.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.dartBoard.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.leftCatBottom.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.leftCatVers.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.leftCatTop.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.rightCatBottom.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.rightCatTop.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: nil)
    }
}
