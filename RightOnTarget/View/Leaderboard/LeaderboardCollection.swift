//  LeaderboardCollection.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import SnapKit
import UIKit

final class LeaderboardCollection: UIView {
    
    var players = [String: Int]()
    var sortedPlayers = [(key: String, value: Int)]()
    
    // MARK: - UI Elements
    
    private lazy var leaderboardCollection: UICollectionView = {
        let layout = createLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(LeaderboardCell.self, forCellWithReuseIdentifier: "LeaderboardCell")
        
        return collection
    }()
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        setupView()
        collectionSetup()
        setupViewConstraints()
        setupShadow()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    // MARK: - Layout Creation
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - Private Methods

private extension LeaderboardCollection {
    private func setupView() {
        addSubview(leaderboardCollection)
    }

    private func setupViewConstraints() {
        leaderboardCollection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func collectionSetup() {
        loadDataFromUserDefaults()
        sortPlayers()
        leaderboardCollection.reloadData()
        print("Collection view reloaded with \(sortedPlayers.count) items")
    }
    
    private func sortPlayers() {
        sortedPlayers = players.sorted { $0.value < $1.value }
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

    private func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
    }
}

// MARK: - UICollectionViewDataSource

extension LeaderboardCollection: UICollectionViewDataSource {
    // Returns the number of items in the section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { sortedPlayers.count }
    
    // Configures and returns the cell for the given index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LeaderboardCell", for: indexPath) as! LeaderboardCell
        let player = sortedPlayers[indexPath.row]
        cell.configure(username: player.key, time: player.value)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension LeaderboardCollection: UICollectionViewDelegate {
    // Handles the selection of a cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? LeaderboardCell {
            animateCell(cell)
        }
    }
    
    // Animates the cell when it is selected
    private func animateCell(_ cell: LeaderboardCell) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.03
        animation.duration = 0.2
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        cell.contentView.layer.add(animation, forKey: nil)
    }
    
    // Animates cells as they scroll into view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleCells = leaderboardCollection.visibleCells
        let delay = 0.05
        
        for (index, cell) in visibleCells.enumerated() {
            UIView.animate(withDuration: 0.5, delay: delay * Double(index), options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)
        }
    }
    
    // Animates the cell when it is about to be displayed
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.5) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    // Animates the cell when it is no longer displayed
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
}
