//
//  CECreditCell.swift
//  CETracker
//
//  Created by Jon Onulak on 7/28/22.
//

import UIKit

class CECreditDetailCell: UITableViewCell {

    @IBOutlet weak var cellBubble: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var topicLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        cellBubble.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
