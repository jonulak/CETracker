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
    
    var requirements = [RenewalRequirement]() {
        didSet { 
            requirementsTableView.reloadData()
            invalidateIntrinsicContentSize()
        }
    }
    
    var credits = [CECredit]() {
        didSet {
            requirementsTableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        requirementsTableView.dataSource = self
        requirementsTableView.register(
            UINib(nibName: "RenewalRequirementCell", bundle: nil),
            forCellReuseIdentifier: "requirementCell"
        )
        cellBubble.layer.cornerRadius = 10
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "requirementCell", for: indexPath) as! RenewalRequirementCell
        let requirement = requirements[indexPath.row]
        let completedCredits = credits.reduce(Float.zero) { partialResult, credit in
            partialResult + (requirement.creditIsValid(credit) ? credit.totalHours : 0)
        }
        cell.completedCredits = completedCredits
        cell.requirementTitleLabel.text = requirement.title
        cell.targetCredits = requirement.creditsRequired
        cell.progressBar.progress = completedCredits / requirement.creditsRequired
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        return cell
    }
}
