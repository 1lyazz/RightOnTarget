//  ViewController.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import UIKit

final class LeaderboardVC: UIViewController {
    
    // Dictionary of players and time records
    var players = [String: Int]()
    var sortedPlayers = [(key: String, value: Int)]()
    
    // MARK: Scene Elements
    
    @IBOutlet private var collectionView: UICollectionView!
    
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
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        makeConstraints()
        bind()
        collectionSetup()
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
    // MARK: Collection Views
    
    private func collectionSetup() {
        loadDataFromUserDefaults()
        sortPlayers()
        setupCollectionView()
        collectionView.reloadData()
        print("Collection view reloaded with \(sortedPlayers.count) items")
    }
       
    private func loadDataFromUserDefaults() {
        let defaults = UserDefaults.standard
        if let savedPlayers = defaults.dictionary(forKey: "players") as? [String: Int] {
            players = savedPlayers
            print("Loaded players: \(players)")
        }
    }
        
    private func saveDataToUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(players, forKey: "players")
    }
        
    private func addPlayer(name: String, time: Int) {
        players[name] = time
        saveDataToUserDefaults()
        print("Added player: \(name) with time: \(time)")
    }
           
    private func sortPlayers() {
        sortedPlayers = players.sorted { $0.value < $1.value }
    }
       
    private func setupCollectionView() {
        collectionView.dataSource = self
        let leaderboardCellNib = UINib(nibName: "LeaderboardCell", bundle: nil)
        collectionView.register(leaderboardCellNib, forCellWithReuseIdentifier: "LeaderboardCell")
        print("Collection view setup completed")
    }
    
    // MARK: Setup Views
    
    private func setupView() {
        view.addSubview(homeButton)
        view.addSubview(boardTitle)
    }
    
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
    
    // MARK: Bindings
    
    private func bind() {
        homeButton.addAction(UIAction(handler: { [weak self] _ in
            playSound(sound: "click", type: "wav")
            self?.dismiss(animated: true, completion: nil)
        }), for: .touchUpInside)
    }
}

// MARK: UICollectionView

extension LeaderboardVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { sortedPlayers.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LeaderboardCell", for: indexPath) as! LeaderboardCell
        let player = sortedPlayers[indexPath.item]
        cell.configure(username: player.key, time: player.value)
        return cell
    }
}
