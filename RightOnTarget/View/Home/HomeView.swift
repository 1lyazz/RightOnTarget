//  HomeView.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import SnapKit
import UIKit

final class HomeView: UIView {
    
    let buttons = HomeButtonsView()
    let animation = HomeAnimationView()
    
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
}

// MARK: - Private Methods

private extension HomeView {
    private func setupView() {
        [animation, buttons].forEach(addSubview)
    }

    private func setupViewConstraints() {
        buttons.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        animation.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
