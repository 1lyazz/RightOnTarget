//  ButtonCell.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import Feedbacks
import UIKit

class ButtonCell: UICollectionViewCell {
    // MARK: IBOutlets

    @IBOutlet private var topButton: UIButton!
    @IBOutlet private var versButton: UIButton!
    @IBOutlet private var bottomButton: UIButton!

    // MARK: Public

    func configure(topImage: UIImage?, versImage: UIImage?, bottomImage: UIImage?) {
        let scaledTopImage = topImage?.resized(to: CGSize(width: 60, height: 40))
        let scaledVersImage = versImage?.resized(to: CGSize(width: 60, height: 50))
        let scaledBottomImage = bottomImage?.resized(to: CGSize(width: 60, height: 30))

        topButton.setImage(scaledTopImage, for: .normal)
        versButton.setImage(scaledVersImage, for: .normal)
        bottomButton.setImage(scaledBottomImage, for: .normal)
    }
    
    // MARK: View Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        bind()
        
        topButton.layer.cornerRadius = 16
        versButton.layer.cornerRadius = 16
        bottomButton.layer.cornerRadius = 16
    }

    // MARK: Actions
    
    let gameInfoVC = GameInfoVC()
    
    func bind() {
        topButton.addAction(UIAction(handler: { [weak self] _ in
            self?.topButton.fck.hapticSelection()
            playSound(sound: "click", type: "wav")

            self?.gameInfoVC.cellIcon = .hexGameLogo
        }), for: .touchUpInside)
        
        versButton.addAction(UIAction(handler: { [weak self] _ in
            self?.versButton.fck.hapticSelection()
            playSound(sound: "click", type: "wav")
            
            self?.gameInfoVC.cellIcon = .appLogo
        }), for: .touchUpInside)
        
        bottomButton.addAction(UIAction(handler: { [weak self] _ in
            self?.bottomButton.fck.hapticSelection()
            playSound(sound: "click", type: "wav")
            
            self?.gameInfoVC.cellIcon = .cardsGameLogo
        }), for: .touchUpInside)
    }
}

extension UIImage {
    func resized(to targetSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
