//
//  LicenseListViewModel.swift
//  CETracker
//
//  Created by Jon Onulak on 8/1/22.
//

import Foundation
import CoreData

class LicenseListViewModel: ObservableObject {

    private var licenseListModel: LicenseListModel
    private var context: NSManagedObjectContext

    var licenses: [License] { licenseListModel.licenses }

    init(context: NSManagedObjectContext) {
        licenseListModel = LicenseListModel(context: context)
        self.context = context
    }

    func addLicense(licenseInfo: LicenseInfo) -> TableViewChange? {
        licenseListModel.addLicense(licenseInfo: licenseInfo)
    }

    func clearLicenses() -> TableViewChange? {
        licenseListModel.clearLicenses()
    }

}
