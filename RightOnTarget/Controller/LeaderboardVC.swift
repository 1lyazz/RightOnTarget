//  ViewController.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import UIKit

final class LeaderboardVC: UIViewController {
    
    private var leaderboardCollection = LeaderboardCollection()
    
    private let homeButton: UIButton = {
        let button = UIButton()
        button.setAppButtonStyle(backgroundImage: "YellowHomeButton")
        return button
    }()
    
    private let boardTitle: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LeaderboardTitle")
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        makeConstraints()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playSound(sound: "leaderboardSound", type: "wav")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Constants.colorGameGradient.frame = view.bounds
        view.layer.insertSublayer(Constants.colorGameGradient, at: 0)
    }
}

private extension LeaderboardVC {
    // MARK: - Setup Views
    
    private func setupView() {
        [homeButton, boardTitle, leaderboardCollection].forEach { view.addSubview($0) }
    }
    
    // MARK: - Constraints
    
    private func makeConstraints() {
        homeButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }

        boardTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(5)
            make.height.equalTo(110)
            make.width.equalTo(300)
        }
        
        leaderboardCollection.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(boardTitle.snp.bottom).offset(20)
            make.bottom.equalTo(view)
        }
    }
    
    // MARK: - Bindings
    
    private func bind() {
        homeButton.addAction(UIAction(handler: { [weak self] _ in
            playSound(sound: "click", type: "wav")
            self?.dismiss(animated: true, completion: nil)
        }), for: .touchUpInside)
    }
}

