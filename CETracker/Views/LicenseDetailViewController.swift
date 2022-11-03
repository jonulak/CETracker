//
//  LicenseDetailViewController.swift
//  CETracker
//
//  Created by Jon Onulak on 9/15/22.
//

import UIKit

class LicenseDetailViewController: UIViewController {

    @IBOutlet weak var moreBarButton: UIBarButtonItem!
    @IBOutlet weak var expirationDateButton: UIButton!
    @IBOutlet weak var licenseNumberLabel: UILabel!
    @IBOutlet weak var licenseNumberStack: UIStackView!
    @IBOutlet weak var requirementsTableView: UITableView!

    let dateFormatter = DateFormatter.CETrackerDateFormatter

    var viewModel: LicenseDetailViewModel!

    private var selectedRenewal: LicenseRenewal! {
        didSet {
            expirationDateButton.setTitle(getLicensePeriodButtonTitle(for: selectedRenewal), for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        requirementsTableView.register(
            UINib(nibName: "RenewalRequirementDetailCell", bundle: nil),
            forCellReuseIdentifier: "RequirementsListCell"
        )
        requirementsTableView.dataSource = self

        selectedRenewal = viewModel.license.renewals.first!
        moreBarButton.menu = moreButtonMenu
        expirationDateButton.menu = expirationDateMenu

        if let licenseNumber = viewModel.license.licenseNumber, licenseNumber != "" {
            licenseNumberStack.isHidden = false
            licenseNumberLabel.text = licenseNumber
        } else {
            licenseNumberStack.isHidden = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private var moreButtonMenu: UIMenu {
        // TODO:  Actions
        let menuActions = [
            UIAction(title: "Edit License Details") { _ in
                print("Edit License Details")
            },
            UIAction(title: "Create Report") { _ in
                print("Create Report")
            }
        ]
        return UIMenu(children: menuActions)
    }

    private var expirationDateMenu: UIMenu {
        let renewalMenu = viewModel.renewals.map { renewal in
            return UIAction(title: getLicensePeriodButtonTitle(for: renewal)) { [weak self] _ in
                guard let self = self else { return }
                self.selectedRenewal = renewal
            }
        }
        return UIMenu(title: "License Periods", children: renewalMenu)
    }

    private func getLicensePeriodButtonTitle(for renewal: LicenseRenewal) -> String {
        var title = dateFormatter.string(from: renewal.periodStartDate)
        title += " - "
        title += dateFormatter.string(from: renewal.periodEndDate)
        return title
    }

}

extension LicenseDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getRenewalRequirements(for: selectedRenewal).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequirementsListCell", for: indexPath) as! RenewalRequirementDetailCell
        let index = indexPath.row
        let requirement = viewModel.getRenewalRequirements(for: selectedRenewal)[index]
        cell.renewalRequirement = requirement
        return cell
    }
}
