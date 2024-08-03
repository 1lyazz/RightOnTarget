//  Cards.swift
//  Cards
//  Created by Ilya Zablotski

import UIKit

class CardView<ShapeType: ShapeLayerProtocol>: UIView, FlippableView {
    // Shape color
    var color: UIColor!
    var cornerRadius = 20
    var isFlipped: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }

    // Coordinates of the first touch
    private var anchorTouchPoint: CGPoint = .init(x: 0, y: 0)
    // Start touch point for the choosen card
    private var startTouchPoint: CGPoint!

    var flipCompletionHandler: ((FlippableView) -> Void)?

    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        self.color = color
        self.setupBorders()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Change the coordinates of the anchor point (anchorTouchPoint)
        self.anchorTouchPoint.x = touches.first!.location(in: window).x - frame.minX
        self.anchorTouchPoint.y = touches.first!.location(in: window).y - frame.minY

        // Save the initial coordinates
        self.startTouchPoint = frame.origin
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.frame.origin.x = touches.first!.location(in: window).x - self.anchorTouchPoint.x
        self.frame.origin.y = touches.first!.location(in: window).y - self.anchorTouchPoint.y
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.frame.origin == self.startTouchPoint {
            self.flip()
        }
        // Returning the card back to the starting position animation
        UIView.animate(withDuration: 0.5) {
            self.frame.origin = self.startTouchPoint
        }
    }

    func flip() {
        // Transition types
        let fromView = self.isFlipped ? self.frontSideView : self.backSideView
        let toView = self.isFlipped ? self.backSideView : self.frontSideView

        // Start animate transition
        UIView.transition(from: fromView, to: toView, duration: 0.5,
                          options: [.transitionFlipFromTop], completion: { _ in
                              // Flip completion handler
                              self.flipCompletionHandler?(self)
                          })

        self.isFlipped.toggle()
    }

    func startFlip() {
        // Transition types
        let fromView = self.isFlipped ? self.frontSideView : self.backSideView
        let toView = self.isFlipped ? self.backSideView : self.frontSideView

        // Start animate transition
        UIView.transition(from: fromView, to: toView, duration: 0.7,
                          options: [.transitionFlipFromTop], completion: { _ in
                              // Wait for 1 sec
                              DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                  UIView.transition(from: toView, to: fromView, duration: 0.5,
                                                    options: [.transitionFlipFromTop], completion: nil)
                                  self.isFlipped.toggle()
                              }
                          })

        self.isFlipped.toggle()
    }

    // Setup card borders
    private func setupBorders() {
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(self.cornerRadius)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
    }

    override func draw(_ rect: CGRect) {
        // Delete earlier added child views
        self.backSideView.removeFromSuperview()
        self.frontSideView.removeFromSuperview()
        // Add new views
        if self.isFlipped {
            self.addSubview(self.backSideView)
            self.addSubview(self.frontSideView)
        } else {
            self.addSubview(self.frontSideView)
            self.addSubview(self.backSideView)
        }
    }

    // View inner margin
    private let margin: Int = 10

    // Frond card side
    lazy var frontSideView: UIView = self.getFrontSideView()
    // Back card side (card shirt)
    lazy var backSideView: UIView = self.getBackSideView()

    // View for frond card side
    private func getFrontSideView() -> UIView {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = .white
        let shapeView = UIView(frame: CGRect(x: margin, y: margin,
                                             width: Int(self.bounds.width) - self.margin * 2,
                                             height: Int(self.bounds.height) - self.margin * 2))
        view.addSubview(shapeView)

        // Create shape layer
        let shapeLayer = ShapeType(size: shapeView.frame.size, fillColor: self.color.cgColor)
        shapeView.layer.addSublayer(shapeLayer)

        // Round the corners of the root layer (for good animation)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(self.cornerRadius)

        return view
    }

    // View for back card side
    private func getBackSideView() -> UIView {
        let view = UIView(frame: self.bounds)

        view.backgroundColor = .white

        // Random design selection for the back card side (card shirt)
        switch ["circle", "cat"].randomElement()! {
        case "circle":
            let layer = BackSideCircle(size: self.bounds.size,
                                       fillColor: #colorLiteral(red: 0.9289420247, green: 0.5919340849, blue: 0.9595891833, alpha: 1))
            view.layer.addSublayer(layer)
        case "cat":
            BackSideCat.addCats(to: view)
        default:
            break
        }

        // Round the corners of the root layer (for good animation)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(self.cornerRadius)

        return view
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol FlippableView: UIView {
    var isFlipped: Bool { get set }
    var flipCompletionHandler: ((FlippableView) -> Void)? { get set }

    func flip()
    func startFlip()
}
