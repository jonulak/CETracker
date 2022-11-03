//
//  LicenseRenewalRequirement+CoreDataClass.swift
//  CETracker
//
//  Created by Jon Onulak on 8/31/22.
//
//

import Foundation
import CoreData

@objc(LicenseRenewalRequirement)
public class LicenseRenewalRequirement: NSManagedObject {

    convenience init(title: String, creditsRequired: Float, credits: [CECredit], context: NSManagedObjectContext) {
        print("init renewal requirement")
        self.init(entity: LicenseRenewalRequirement.entity(), insertInto: context)
        self.title = title
        self.creditsRequired = creditsRequired
        credits.forEach { $0.addToLicenseRequirementsApplied(self) }
    }

    var title: String {
        get { title_! }
        set { title_ = newValue }
    }

    var currentCredits: Float {
        let creditHoursKeyPath: KeyPath<CECredit, Float>
        switch self.title {
        case "Live": creditHoursKeyPath = \.liveHours
        default: creditHoursKeyPath = \.totalHours
        }
        return appliedCredits.reduce(Float.zero) { partialResult, credit in
            partialResult + credit[keyPath: creditHoursKeyPath]
        }
    }

}
