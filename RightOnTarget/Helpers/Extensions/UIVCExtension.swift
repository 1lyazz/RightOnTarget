//  UIVCExtension.swift
//  RightOnTarget
//  Created by Ilya Zablotski

import UIKit

extension UIViewController {
    func presentVC(_ viewController: UIViewController) {
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Hiding the keyboard by tapping the screen
    func setupGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}
