//
//  SemiCircleProgressBarViewController.swift
//  CETracker
//
//  Created by Jon Onulak on 9/20/22.
//

import UIKit

@IBDesignable
class SemiCircleProgressBar: UIView {

    private var barForeground: SemiCircleBar!
    private var barBackground: SemiCircleBar!
    private var currentProgressLabel: UILabel!
    private var targetProgressLabel: UILabel!
    var currentValueLabelInset: CGFloat = 5

    var currentValue: String? {
        get { currentProgressLabel.text }
        set { currentProgressLabel.text = newValue }
    }

    var targetValue: String? {
        get { targetProgressLabel.text }
        set { targetProgressLabel.text = newValue }
    }

    var progress: CGFloat = 0.5 {
        didSet {
            updateProgress()
        }
    }

    var barWidth: CGFloat {
        get {
            barForeground.barWidth
        }
        set {
            barBackground.barWidth = newValue
            barForeground.barWidth = newValue
        }
    }

    private func updateProgress() {
        guard progress >= 0 else {
            progress = 0
            return
        }
        guard progress <= 1 else {
            progress = 1
            return
        }
        barForeground.endAngle = barBackground.startAngle + (barBackground.endAngle - barBackground.startAngle) * progress
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupView()
    }

    func setupView() {
        backgroundColor = .clear

        barBackground = SemiCircleBar(frame: frame)
        barBackground.fillColor = UIColor.gray
        barBackground.translatesAutoresizingMaskIntoConstraints = false
        addSubview(barBackground)

        barForeground = SemiCircleBar(frame: frame)
        barForeground.fillColor = UIColor.tintColor
        barForeground.translatesAutoresizingMaskIntoConstraints = false
        barForeground.barWidth = barBackground.barWidth
        addSubview(barForeground)

        currentProgressLabel = UILabel()
        currentProgressLabel.text = "50"
        currentProgressLabel.adjustsFontSizeToFitWidth = true
        currentProgressLabel.font = UIFont.preferredFont(forTextStyle: .body)
        currentProgressLabel.font = currentProgressLabel.font.withSize(300)
        currentProgressLabel.minimumScaleFactor = 0.01
        currentProgressLabel.numberOfLines = 1
        currentProgressLabel.textAlignment = .center
        currentProgressLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(currentProgressLabel)

        targetProgressLabel = UILabel()
        targetProgressLabel.text = "100"
        targetProgressLabel.adjustsFontSizeToFitWidth = true
        targetProgressLabel.font = UIFont.preferredFont(forTextStyle: .body)
        targetProgressLabel.font = targetProgressLabel.font.withSize(300)
        targetProgressLabel.minimumScaleFactor = 0.01
        targetProgressLabel.numberOfLines = 1
        targetProgressLabel.textAlignment = .center
        targetProgressLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(targetProgressLabel)

        NSLayoutConstraint.activate([
            barBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            barBackground.topAnchor.constraint(equalTo: topAnchor),
            barBackground.bottomAnchor.constraint(equalTo: bottomAnchor),
            barBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            barBackground.heightAnchor.constraint(equalTo: widthAnchor),
            barForeground.centerXAnchor.constraint(equalTo: centerXAnchor),
            barForeground.centerYAnchor.constraint(equalTo: centerYAnchor),
            barForeground.widthAnchor.constraint(equalTo: widthAnchor),
            barForeground.heightAnchor.constraint(equalTo: heightAnchor),
            currentProgressLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            currentProgressLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            currentProgressLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: (-barWidth * 2) - currentValueLabelInset),
            currentProgressLabel.heightAnchor.constraint(equalTo: currentProgressLabel.widthAnchor),
            targetProgressLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            targetProgressLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            targetProgressLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25),
            targetProgressLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5)
        ])

        updateProgress()
    }

}
