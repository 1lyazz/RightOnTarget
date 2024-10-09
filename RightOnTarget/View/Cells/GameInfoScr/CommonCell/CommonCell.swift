//  CommonCell.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import UIKit

class CommonCell: UICollectionViewCell {
    // MARK: - IBOutlets

    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var topImageView: UIImageView!
    @IBOutlet private var versImageView: UIImageView!
    @IBOutlet private var bottomImageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!

    // MARK: - Public

    func configure(icon: UIImage?, topImage: UIImage?, versImage: UIImage?, bottomImage: UIImage?, text: String) {
        iconImageView.image = icon
        topImageView.image = topImage
        versImageView.image = versImage
        bottomImageView.image = bottomImage
        textLabel.text = text
    }

    // MARK: - View Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 16
    }
}
