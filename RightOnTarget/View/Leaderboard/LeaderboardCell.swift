//  LeaderboardCell.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import SnapKit
import UIKit

final class LeaderboardCell: UICollectionViewCell {
    
    private lazy var usernameLabel: UILabel = createLabel(fontSize: 25)
    private lazy var separator: UILabel = createLabel(fontSize: 30, text: "|")
    private lazy var timeRecordLabel: UILabel = createLabel(fontSize: 25)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        makeConstraints()
        setupAppearance()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = .systemYellow
        [usernameLabel, separator, timeRecordLabel].forEach(contentView.addSubview)
    }
    
    private func setupAppearance() {
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
    }
    
    // MARK: Constraints
    
    private func makeConstraints() {
        usernameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.snp.leading).inset(30)
        }

        separator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        timeRecordLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(self.snp.trailing).inset(30)
        }
    }
    
    // MARK: Public
    
    func configure(username: String, time: Int) {
        usernameLabel.text = username
        timeRecordLabel.text = "\(time)"
    }
    
    // MARK: Private
    
    private func createLabel(fontSize: CGFloat, text: String? = nil) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        label.textColor = .white
        label.textAlignment = .center
        label.text = text
        label.addShadow()
        return label
    }
    
    private func animateCell() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.03
        animation.duration = 0.2
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        contentView.layer.add(animation, forKey: nil)
    }
}
