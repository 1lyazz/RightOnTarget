//  ViewController.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import UIKit

class LeaderboardVC: UIViewController {
    // Dictionary of players and time records
    var players =  [String: Int]()
    var sortedPlayers = [(key: String, value: Int)]()
    
    // MARK: IBOutlets

    @IBOutlet private var collectionView: UICollectionView!
    
    // MARK: Scene Elements

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
    
    // MARK: Constraints
    
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
        view.addSubview(boardTitle)
    }
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        setupView()
        makeConstraints()
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Getting data from UserDefaults
        if let savedUserName = UserDefaults.standard.string(forKey: "userName"),
           let savedTotalTime = UserDefaults.standard.value(forKey: "totalTime") as? Int {
            players[savedUserName] = savedTotalTime
        }

        // Sort data
        sortedPlayers = players.sorted { $0.value < $1.value }
        
        // Collection register
        collectionView.dataSource = self
        let LeaderboardCellNib = UINib(nibName: "LeaderboardCell", bundle: nil)
        collectionView.register(LeaderboardCellNib, forCellWithReuseIdentifier: "LeaderboardCell")
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

extension LeaderboardVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { sortedPlayers.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LeaderboardCell", for: indexPath) as! LeaderboardCell
        let player = sortedPlayers[indexPath.item]
        cell.configure(username: player.key, time: player.value)
        return cell
    }
}
