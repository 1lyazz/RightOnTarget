//  HomeVC.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import Feedbacks
import SnapKit
import UIKit

final class HomeVC: UIViewController {
    
    enum Constants {
        static let appDarkGray = UIColor(red: 37/255, green: 37/255, blue: 37/255, alpha: 1)
    }
    
    // MARK: Scene Elements
    
    private let homeView = HomeView()
    private lazy var hexGameButton = homeView.buttons.hexGameButton
    private lazy var sliderGameButton = homeView.buttons.sliderGameButton
    private lazy var cardGameButton = homeView.buttons.cardGameButton
    private lazy var gameInfoButton = homeView.buttons.gameInfoButton
    private lazy var leaderboardButton = homeView.buttons.leaderboardButton
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
        setupView()
        makeConstraints()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MusicPlayer.shared.startBackgroundMusic(backgroundMusicFileName: "info")
        homeView.animation.startAnimation()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        MusicPlayer.shared.stopBackgroundMusic()
    }
}

private extension HomeVC {
    private func setupStyle() {
        view.backgroundColor = Constants.appDarkGray
    }
    
    // MARK: Setup View
    
    private func setupView() {
        view.addSubview(homeView)
    }
    
    // MARK: Constraints
    
    private func makeConstraints() {
        homeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: Bindings
    
    private func bind() {
        hexGameButton.addAction(UIAction(handler: { [weak self] _ in
            self?.hexGameButton.fck.hapticSelection()
            playSound(sound: "click", type: "wav")
            let colorGameVC = ColorGameVC()
            self?.presentVC(colorGameVC)
        }), for: .touchUpInside)
        
        sliderGameButton.addAction(UIAction(handler: { [weak self] _ in
            self?.sliderGameButton.fck.hapticSelection()
            playSound(sound: "click", type: "wav")
            let sliderGameVC: SliderGameVC = {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(identifier: "SliderGameVC")
                return viewController as! SliderGameVC
            }()
            self?.presentVC(sliderGameVC)
        }), for: .touchUpInside)
        
        cardGameButton.addAction(UIAction(handler: { [weak self] _ in
            self?.cardGameButton.fck.hapticSelection()
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
}
