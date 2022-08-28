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
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        licenses = License.fetchAll(context: context)
        self.context = context
    }
    
    mutating func addLicense(for state: USState) -> TableViewChange? {
        guard License.with(state: state, context: context) == nil else { return nil }
        let license = License(context: context)
        license.state = state
        licenses.insert(license, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        return (.addition, [indexPath])
    }
    
}
