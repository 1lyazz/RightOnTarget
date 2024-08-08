//  Shapes.swift
//  Cards
//  Created by Ilya Zablotski

import UIKit

// MARK: Card back design (circles)

class BackSideCircle: CAShapeLayer, ShapeLayerProtocol {
    
    required init(size: CGSize, fillColor: CGColor) {
        super.init()

        let path = UIBezierPath()

        // Draw 15 circles
        for _ in 1...15 {
            // Circle center coordinates
            let randomX = Int.random(in: 0...Int(size.width))
            let randomY = Int.random(in: 0...Int(size.height))
            let center = CGPoint(x: randomX, y: randomY)
            // Move pointer to the circle centre
            path.move(to: center)
            // Random radius
            let radius = Int.random(in: 5...15)
            // Draw circle
            path.addArc(withCenter: center, radius: CGFloat(radius),
                        startAngle: 0, endAngle: .pi * 2, clockwise: true)
        }

        // Path initialization
        self.path = path.cgPath
        self.strokeColor = fillColor
        self.fillColor = fillColor
        self.lineWidth = 1
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Card back design (cats)

class BackSideCat {
    static func addCats(to view: UIView, count: Int = 8) {
        for _ in 1...count {
            let randomX = CGFloat.random(in: 0...view.bounds.width)
            let randomY = CGFloat.random(in: 0...view.bounds.height)
            let center = CGPoint(x: randomX, y: randomY)

            let diameter = CGFloat.random(in: 30...50)
            let frame = CGRect(x: center.x - diameter / 2,
                               y: center.y - diameter / 2,
                               width: diameter, height: diameter)

            let imageView = UIImageView(frame: frame)
            imageView.image = UIImage(named: "LeftCat")
            view.addSubview(imageView)
        }
    }
}

// MARK: Circle

class CircleShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()

        // Сalculating circle parameters
        let radius = ([size.width, size.height].min() ?? 0) / 2
        let centerX = size.width / 2
        let centerY = size.height / 2

        // Draw circle
        let path = UIBezierPath(arcCenter: CGPoint(x: centerX, y: centerY), radius: radius,
                                startAngle: 0, endAngle: .pi * 2, clockwise: true)
        path.close()

        // Path initialization
        self.path = path.cgPath
        self.fillColor = fillColor
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Square

class SquareShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()

        // Сalculating square parameters
        let edgeSize = ([size.width, size.height].min() ?? 0)

        // Draw square
        let rect = CGRect(x: 0, y: 20, width: edgeSize, height: edgeSize)
        let path = UIBezierPath(rect: rect)
        path.close()

        // Path initialization
        self.path = path.cgPath
        self.fillColor = fillColor
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Cross

class CrossShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()

        // Draw cross
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: size.width, y: size.height))
        path.move(to: CGPoint(x: size.width, y: 0))
        path.addLine(to: CGPoint(x: 0, y: size.height))

        // Path initialization
        self.path = path.cgPath
        self.strokeColor = fillColor
        self.lineWidth = 5
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// // MARK: Fill

class FillShape: CAShapeLayer, ShapeLayerProtocol {
    required init(size: CGSize, fillColor: CGColor) {
        super.init()

        // Draw fill shape
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        // Path initialization
        self.path = path.cgPath
        self.fillColor = fillColor
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol ShapeLayerProtocol: CAShapeLayer {
    init(size: CGSize, fillColor: CGColor)
}

extension ShapeLayerProtocol {
    init() {
        fatalError("init() can't be used to create an instance")
    }
}
