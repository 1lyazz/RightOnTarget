//  HomeButtonsView.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import SnapKit
import UIKit

final class HomeButtonsView: UIView {

    // MARK: - UI Elements
    
    let hexGameButton: UIButton = {
        let button = UIButton()
        button.setAppButtonStyle(backgroundImage: "WhiteButton", title: "HEX", titleColor: .darkText)
        return button
    }()
    
    let sliderGameButton: UIButton = {
        let button = UIButton()
        button.setAppButtonStyle(backgroundImage: "GrayButton", title: "SLIDER", titleColor: .white)
        return button
    }()
    
    let cardGameButton: UIButton = {
        let button = UIButton()
        button.setAppButtonStyle(backgroundImage: "WhiteButton", title: "CARDS", titleColor: .darkText)
        return button
    }()
    
    let gameInfoButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "GameInfoButton"), for: .normal)
        return button
    }()
    
    let leaderboardButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "LeaderboardButton"), for: .normal)
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
}

// MARK: - Private Methods

private extension HomeButtonsView {
    private func setupView() {
        [sliderGameButton, hexGameButton, cardGameButton, gameInfoButton, leaderboardButton].forEach(addSubview)
    }

    private func setupViewConstraints() {
        sliderGameButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(115)
            make.height.equalTo(52)
            make.width.equalTo(200)
        }
        
        hexGameButton.snp.makeConstraints { make in
            make.centerY.equalTo(sliderGameButton)
            make.trailing.equalTo(sliderGameButton.snp.trailing).inset(250)
            make.height.equalTo(52)
            make.width.equalTo(200)
        }
        
        cardGameButton.snp.makeConstraints { make in
            make.centerY.equalTo(sliderGameButton)
            make.leading.equalTo(sliderGameButton.snp.leading).inset(250)
            make.height.equalTo(52)
            make.width.equalTo(200)
        }
        
        gameInfoButton.snp.makeConstraints { make in
            make.bottom.equalTo(sliderGameButton.snp.top).offset(-100)
            make.trailing.equalTo(sliderGameButton.snp.leading).offset(-170)
            make.width.equalTo(90)
            make.height.equalTo(90)
        }
        
        leaderboardButton.snp.makeConstraints { make in
            make.bottom.equalTo(sliderGameButton.snp.top).offset(-180)
            make.leading.equalTo(sliderGameButton.snp.trailing).offset(150)
            make.width.equalTo(90)
            make.height.equalTo(90)
        }
    }
}
