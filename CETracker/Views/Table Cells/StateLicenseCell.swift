//
//  StateLicenseCell.swift
//  CETracker
//
//  Created by Jon Onulak on 8/1/22.
//

import UIKit

class StateLicenseCell: UITableViewCell {

    @IBOutlet weak var stateNameLabel: UILabel!
    @IBOutlet weak var expirationDateLabel: UILabel!
    @IBOutlet weak var cellBubble: UIView!
    @IBOutlet private weak var requirementsTableView: UITableView!

    let cellBubbleCornerRadius: CGFloat = 5

    var requirements = [LicenseRenewalRequirement]() {
        didSet {
            requirementsTableView.reloadData()
            layoutIfNeeded()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        requirementsTableView.dataSource = self
        requirementsTableView.register(
            UINib(nibName: "RenewalRequirementProgressBarCell", bundle: nil),
            forCellReuseIdentifier: "requirementCell"
        )

        cellBubble.layer.cornerRadius = cellBubbleCornerRadius
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension StateLicenseCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        requirements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requirementCell", for: indexPath) as! RenewalRequirementProgressBarCell
        let requirement = requirements[indexPath.row]
        let completedCredits = requirement.appliedCredits.reduce(Float.zero) { partialResult, credit in
            partialResult + credit.totalHours
        }
        cell.completedCredits = completedCredits
        cell.requirementTitleLabel.text = requirement.title
        cell.targetCredits = requirement.creditsRequired
        cell.progressBar.progress = completedCredits / requirement.creditsRequired
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
}
