//  HomeAnimationView.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import SnapKit
import UIKit

final class HomeAnimationView: UIView {
        
    // MARK: - UI Elements
    
    private let appLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppLogo")
        return imageView
    }()
    
    private let appLogoLight: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppLogoLight")
        return imageView
    }()
    
    private let dartBoard: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "DartBoard")
        return imageView
    }()
    
    private let rightCatBottom: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "RightCat")
        return imageView
    }()
    
    private let rightCatTop: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "RightCat")
        return imageView
    }()
    
    private let leftCatBottom: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LeftCat")
        return imageView
    }()
    
    private let leftCatVers: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LeftCat")
        return imageView
    }()
    
    private let leftCatTop: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LeftCat")
        return imageView
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
    
    func startAnimation() {
        let animations = [
            AnimationLayer(layer: appLogo.layer, scaleX: 0.9, scaleY: 0.9),
            AnimationLayer(layer: appLogoLight.layer, scaleX: 1.1, scaleY: 1.1),
            AnimationLayer(layer: dartBoard.layer, scaleX: 1.1, scaleY: 1.1),
            AnimationLayer(layer: leftCatBottom.layer, scaleX: 1.2, scaleY: 1.2),
            AnimationLayer(layer: leftCatVers.layer, scaleX: 0.9, scaleY: 0.9),
            AnimationLayer(layer: leftCatTop.layer, scaleX: 1.1, scaleY: 1.1),
            AnimationLayer(layer: rightCatBottom.layer, scaleX: 0.9, scaleY: 0.9),
            AnimationLayer(layer: rightCatTop.layer, scaleX: 1.2, scaleY: 1.2)
        ]

        LayerAnimator.animateLayers(layers: animations, duration: 3)
    }
}

// MARK: - Private Methods

private extension HomeAnimationView {
    private func setupView() {
        [appLogoLight, appLogo, dartBoard, rightCatBottom,
         rightCatTop, leftCatBottom, leftCatVers, leftCatTop].forEach(addSubview)
    }

    private func setupViewConstraints() {
        appLogo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-70)
            make.width.equalTo(350)
            make.height.equalTo(250)
        }

        appLogoLight.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-70)
            make.width.equalTo(400)
            make.height.equalTo(300)
        }

        dartBoard.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(3)
            make.leading.equalTo(appLogo.snp.trailing).offset(80)
            make.width.equalTo(130)
            make.height.equalTo(130)
        }
        
        rightCatBottom.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-70)
            make.leading.equalTo(appLogo.snp.trailing).offset(80)
            make.width.equalTo(40)
            make.height.equalTo(36)
        }
        
        rightCatTop.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-100)
            make.leading.equalTo(appLogo.snp.trailing).offset(160)
            make.width.equalTo(40)
            make.height.equalTo(36)
        }
        
        leftCatBottom.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(20)
            make.trailing.equalTo(appLogo.snp.leading).offset(-130)
            make.width.equalTo(40)
            make.height.equalTo(36)
        }
        
        leftCatVers.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-70)
            make.trailing.equalTo(appLogo.snp.leading).offset(-40)
            make.width.equalTo(40)
            make.height.equalTo(36)
        }
        
        leftCatTop.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-140)
            make.trailing.equalTo(appLogo.snp.leading).offset(-110)
            make.width.equalTo(40)
            make.height.equalTo(36)
        }
    }
}
