//
//  RenewalRequirementCell.swift
//  CETracker
//
//  Created by Jon Onulak on 8/2/22.
//

import UIKit

class RenewalRequirementProgressBarCell: UITableViewCell {

    @IBOutlet weak var requirementTitleLabel: UILabel!
    @IBOutlet weak var creditCounts: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!

    var completedCredits: Float = 0 {
        didSet {
            updateCreditProgress()
        }
    }

    var targetCredits: Float = 30 {
        didSet {
            updateCreditProgress()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        updateCreditProgress()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    private func updateCreditProgress() {
        creditCounts.text = "\(completedCredits)/\(targetCredits)"
        progressBar.progress = min(completedCredits / targetCredits, 1.0)
    }

}
