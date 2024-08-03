//  GameInfoVC.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import UIKit

class GameInfoVC: UIViewController {
    var cellIcon: UIImage = .hexGameLogo
    
    // MARK: IBOutlets

    @IBOutlet private var collectionView: UICollectionView!

    // MARK: Scene Elements
    
    private let homeButton: UIButton = {
        let button = UIButton()
        button.setAppButtonStyle(backgroundImage: "BlueHomeButton")
        return button
    }()

    private let infoTitle: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "InfoTitle")
        return imageView
    }()

    // MARK: Constraints
    
    private func makeConstraints() {
        homeButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }

        infoTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.height.equalTo(50)
            make.width.equalTo(249)
        }
    }

    // MARK: Actions
    
    private func bind() {
        homeButton.addAction(UIAction(handler: { [weak self] _ in
            playSound(sound: "click", type: "wav")
            self?.dismiss(animated: true, completion: nil)
        }), for: .touchUpInside)
    }

    // MARK: Setup Views
    
    private func setupView() {
        view.addSubview(homeButton)
        view.addSubview(infoTitle)
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
        collectionView.dataSource = self
        let buttomCellNib = UINib(nibName: "ButtonCell", bundle: nil)
        collectionView.register(buttomCellNib, forCellWithReuseIdentifier: "ButtonCell")
        let commonCellNib = UINib(nibName: "CommonCell", bundle: nil)
        collectionView.register(commonCellNib, forCellWithReuseIdentifier: "CommonCell")
    }
}

extension GameInfoVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 4 }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
            cell.configure(topImage: .hexGameLogo, versImage: .appLogo, bottomImage: .cardsGameLogo)
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonCell", for: indexPath) as! CommonCell
            cell.configure(icon: cellIcon, topImage: .rulesHumans, versImage: .rulesGamepad, bottomImage: .rulesGears, text: "Rules")
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonCell", for: indexPath) as! CommonCell
            cell.configure(icon: cellIcon, topImage: .leaderboardButton, versImage: .leaderboardButton, bottomImage: .leaderboardButton, text: "Leaderboard")
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonCell", for: indexPath) as! CommonCell
            cell.configure(icon: cellIcon, topImage: .video, versImage: .video, bottomImage: .video, text: "Game Video")
            return cell
        }
    }
}
