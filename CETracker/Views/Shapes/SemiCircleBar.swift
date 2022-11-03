//
//  SemiCircleBar.swift
//  CETracker
//
//  Created by Jon Onulak on 9/18/22.
//

import Foundation
import UIKit

@IBDesignable
class SemiCircleBar: UIView {

    var path: UIBezierPath!
    var fillColor: UIColor!
    var strokeColor: UIColor!
    var startAngle = CGFloat.pi * 0.75 {
        didSet {
            if startAngle > endAngle { endAngle += CGFloat.pi * 2 }
        }
    }
    var endAngle = CGFloat.pi * 0.25 + CGFloat.pi * 2 {
        didSet {
            if startAngle > endAngle { endAngle += CGFloat.pi * 2 }
        }
    }
    var barWidth: CGFloat = 5

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        isOpaque = false
        clearsContextBeforeDrawing = true
    }

    private func createArc() {
        let width = min(frame.size.width, frame.size.height)
        let center = CGPoint(x: frame.midX, y: frame.midY)
        let outerRadius = (width / 2)
        let innerRadius = outerRadius - barWidth

        path = UIBezierPath(arcCenter: center, radius: outerRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.addLine(to: pointOnCircle(center: center, radius: innerRadius, angle: endAngle))
        path.addArc(withCenter: center, radius: innerRadius, startAngle: endAngle, endAngle: startAngle, clockwise: false)
        path.close()
    }

    private func pointOnCircle(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        let x = center.x + radius * cos(angle)
        let y = center.y + radius * sin(angle)

        return CGPoint(x: x, y: y)
    }

    override func draw(_ rect: CGRect) {
        createArc()

        fillColor.setFill()
        path.fill()
    }

}
