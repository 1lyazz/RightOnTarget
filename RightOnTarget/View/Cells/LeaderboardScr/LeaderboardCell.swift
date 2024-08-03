//  LraderboardCell.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import UIKit

class LeaderboardCell: UICollectionViewCell {
    // MARK: IBOutlets
    
    @IBOutlet private var usernameLabel: UILabel!
    @IBOutlet private var timeRecordLabel: UILabel!
    
    // MARK: Publick
    
    func configure(username: String, time: Int) {
        usernameLabel.text = username
        timeRecordLabel.text = "\(time)"
    }
    
    // MARK: View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius = 16
    }
}
