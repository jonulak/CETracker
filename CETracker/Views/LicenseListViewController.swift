//
//  LicenseListViewController.swift
//  CETracker
//
//  Created by Jon Onulak on 7/31/22.
//

import Foundation
import UIKit
import Combine

class LicenseListViewController: UIViewController {
    
    @IBOutlet weak var licenseListTableView: UITableView!
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var cancellables = Set<AnyCancellable>()
    var licenseListViewModel: LicenseListViewModel!
    
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
        let state = USState.allCases.randomElement()!
        if let change = licenseListViewModel.addLicense(for: state) {
            licenseListTableView.animateUpdates(changes: change)            
        }
    }
    
}

extension LicenseListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        licenseListViewModel.licenses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO:  License expiration date
        let cell = tableView.dequeueReusableCell(withIdentifier: "LicenseListCell", for: indexPath) as! StateLicenseCell
        let license = licenseListViewModel.licenses[indexPath.row]
        cell.credits = licenseListViewModel.getValidCreditsFor(state: license.state)
        cell.expirationDateLabel.text = "00/00/00"
        cell.stateNameLabel.text = license.state.stateName
        cell.requirements = license.state.creditRequirements
        return cell
    }
}
