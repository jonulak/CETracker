//
//  LicenseRenewalRequirement+CoreDataProperties.swift
//  CETracker
//
//  Created by Jon Onulak on 9/1/22.
//
//

import Foundation
import CoreData

extension LicenseRenewalRequirement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LicenseRenewalRequirement> {
        return NSFetchRequest<LicenseRenewalRequirement>(entityName: "LicenseRenewalRequirement")
    }

    @NSManaged public var title_: String?
    @NSManaged public var creditsRequired: Float
    @NSManaged public var appliedCredits: Set<CECredit>
    @NSManaged public var licenseRenewal: LicenseRenewal

}

// MARK: Generated accessors for appliedCredits
extension LicenseRenewalRequirement {

    @objc(addAppliedCreditsObject:)
    @NSManaged public func addToAppliedCredits(_ value: CECredit)

    @objc(removeAppliedCreditsObject:)
    @NSManaged public func removeFromAppliedCredits(_ value: CECredit)

    @objc(addAppliedCredits:)
    @NSManaged public func addToAppliedCredits(_ values: NSSet)

    @objc(removeAppliedCredits:)
    @NSManaged public func removeFromAppliedCredits(_ values: NSSet)

}

extension LicenseRenewalRequirement: Identifiable {

}
