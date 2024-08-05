//  ColorButtonsView.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import SnapKit
import UIKit

final class ColorButtonsView: UIView {
    
    // MARK: - UI Elements
    
    let colorButton1: UIButton = {
        let button = UIButton()
        button.setColorButtonShape()
        return button
    }()
    
    let colorButton2: UIButton = {
        let button = UIButton()
        button.setColorButtonShape()
        return button
    }()
    
    let colorButton3: UIButton = {
        let button = UIButton()
        button.setColorButtonShape()
        return button
    }()
    
    let colorButton4: UIButton = {
        let button = UIButton()
        button.setColorButtonShape()
        return button
    }()
    
    let colorButton5: UIButton = {
        let button = UIButton()
        button.setColorButtonShape()
        return button
    }()
    
    let colorButton6: UIButton = {
        let button = UIButton()
        button.setColorButtonShape()
        return button
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
}

// MARK: - Private Methods

private extension ColorButtonsView {
    private func setupView() {
        [colorButton1, colorButton2, colorButton3, colorButton4,
         colorButton5, colorButton6].forEach(addSubview)
    }

    private func setupViewConstraints() {
        colorButton1.snp.makeConstraints { make in
            make.trailing.equalTo(colorButton2.snp.trailing).inset(170)
            make.centerY.equalToSuperview().offset(55)
        }
        
        colorButton2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(55)
        }
        
        colorButton3.snp.makeConstraints { make in
            make.leading.equalTo(colorButton2.snp.leading).inset(170)
            make.centerY.equalToSuperview().offset(55)
        }
        
        colorButton4.snp.makeConstraints { make in
            make.trailing.equalTo(colorButton5.snp.trailing).inset(170)
            make.top.equalTo(colorButton2.snp.bottom).offset(20)
        }
        
        colorButton5.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(colorButton2.snp.bottom).offset(20)
        }
        
        colorButton6.snp.makeConstraints { make in
            make.leading.equalTo(colorButton5.snp.leading).inset(170)
            make.top.equalTo(colorButton2.snp.bottom).offset(20)
        }
    }
}
