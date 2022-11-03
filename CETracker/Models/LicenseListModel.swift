//
//  LicenseListModel.swift
//  CETracker
//
//  Created by Jon Onulak on 8/1/22.
//

import Foundation
import CoreData

struct LicenseListModel {

    var licenses: [License]
    private var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        licenses = License.fetchAll(context: context)
        self.context = context
    }

    mutating func addLicense(licenseInfo: LicenseInfo) -> TableViewChange? {
        guard let state = licenseInfo.state, License.with(state: state, context: context) == nil else { return nil }
        guard let license = License(state: state,
                                    isImmunizer: licenseInfo.isImmunizer,
                                    periodStartDate: licenseInfo.startDate,
                                    periodEndDate: licenseInfo.endDate,
                                    context: context) else {
            return nil
        }
        license.licenseNumber = licenseInfo.licenseNumber
        licenses.insert(license, at: 0)
        try? context.save()
        let indexPath = IndexPath(row: 0, section: 0)
        return (.addition, [indexPath])
    }

    mutating func clearLicenses() -> TableViewChange? {
        guard !licenses.isEmpty else { return nil }
        let indexPaths = (0..<licenses.count).map { IndexPath(row: $0, section: 0) }
        licenses.forEach { context.delete($0) }
        licenses.removeAll()
        try? context.save()
        return (.deletion, indexPaths)
    }

}
