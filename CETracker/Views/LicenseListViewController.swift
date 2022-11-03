//
//  LicenseListViewController.swift
//  CETracker
//
//  Created by Jon Onulak on 7/31/22.
//

import Foundation
import UIKit
import Combine
import SwiftUI

class LicenseListViewController: UIViewController {
    @IBOutlet weak var licenseListTableView: UITableView!
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var cancellables = Set<AnyCancellable>()
    var licenseListViewModel: LicenseListViewModel!
    let dateFormatter = DateFormatter.CETrackerDateFormatter

    override func viewDidLoad() {
        super.viewDidLoad()

        licenseListViewModel = LicenseListViewModel(context: context)
        licenseListTableView.dataSource = self
        licenseListTableView.register(
            UINib(nibName: "StateLicenseCell", bundle: nil),
            forCellReuseIdentifier: "LicenseListCell"
        )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        licenseListTableView.reloadData()
    }

    @IBAction func addLicensesTapped(_ sender: Any) {
        let addLicenseVC = UIHostingController(rootView: AddLicenseView { [weak self] licenseInfo in
            guard let self = self else { return }
            self.dismiss(animated: true)
            if let changes = self.licenseListViewModel.addLicense(licenseInfo: licenseInfo) {
                self.licenseListTableView.animateUpdates(changes: changes)
            }
        })

        if let sheetController = addLicenseVC.presentationController as? UISheetPresentationController {
            sheetController.detents = [.medium()]
            sheetController.prefersGrabberVisible = true
        }

        present(addLicenseVC, animated: true)
    }

    @IBAction func clearButtonTapped(_ sender: Any) {
        if let changes = licenseListViewModel.clearLicenses() {
            licenseListTableView.animateUpdates(changes: changes)
        }
    }
}

// MARK: - UITableViewDataSource
extension LicenseListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        licenseListViewModel.licenses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LicenseListCell", for: indexPath) as! StateLicenseCell
        cell.selectionStyle = .none

        let license = licenseListViewModel.licenses[indexPath.row]
        let renewal = license.renewals.first!

        cell.expirationDateLabel.text = dateFormatter.string(from: renewal.periodEndDate)
        cell.stateNameLabel.text = license.state.stateName
        cell.requirements = Array(renewal.licenseRenewalRequirements)

        return cell
    }
}
