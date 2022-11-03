//
//  RenewalRequirementDetailCell.swift
//  CETracker
//
//  Created by Jon Onulak on 9/18/22.
//

import UIKit

class RenewalRequirementDetailCell: UITableViewCell {

    @IBOutlet weak var progressView: SemiCircleProgressBar!
    @IBOutlet weak var creditsTable: NestedTableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellBubble: UIView!

    let numberFormatter = NumberFormatter.CETrackerNumberFormatter

    var renewalRequirement: LicenseRenewalRequirement! {
        didSet {
            titleLabel.text = renewalRequirement.title
            progressView.progress = CGFloat(renewalRequirement.currentCredits / renewalRequirement.creditsRequired)
            progressView.currentValue = numberFormatter.string(from: renewalRequirement.currentCredits as NSNumber)
            progressView.targetValue = numberFormatter.string(from: renewalRequirement.creditsRequired as NSNumber)
            credits = renewalRequirement.appliedCredits.sorted { $0.date > $1.date }
        }
    }

    private var credits = [CECredit]() {
        didSet {
            creditsTable.reloadData()
            creditsTable.layoutIfNeeded()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        creditsTable.register(
            UINib(nibName: "RenewalDetailCreditCell", bundle: nil),
            forCellReuseIdentifier: "CreditCell"
        )
        creditsTable.dataSource = self
        cellBubble.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension RenewalRequirementDetailCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        credits.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreditCell", for: indexPath) as! RenewalDetailCreditCell
        let credit = credits[indexPath.row]
        cell.titleLabel.text = credit.title
        return cell
    }

}
