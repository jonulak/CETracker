//
//  LicenseRenewal+CoreDataProperties.swift
//  CETracker
//
//  Created by Jon Onulak on 9/2/22.
//
//

import Foundation
import CoreData

extension LicenseRenewal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LicenseRenewal> {
        return NSFetchRequest<LicenseRenewal>(entityName: "LicenseRenewal")
    }

    @NSManaged public var isImmunizer: Bool
    @NSManaged public var periodEndDate_: Date?
    @NSManaged public var periodStartDate_: Date?
    @NSManaged public var status_: String?
    @NSManaged public var license: License?
    @NSManaged public var licenseRenewalRequirements_: Set<LicenseRenewalRequirement>

}

// MARK: Generated accessors for licenseRenewalRequirements_
extension LicenseRenewal {

    @objc(addLicenseRenewalRequirements_Object:)
    @NSManaged public func addToLicenseRenewalRequirements_(_ value: LicenseRenewalRequirement)

    @objc(removeLicenseRenewalRequirements_Object:)
    @NSManaged public func removeFromLicenseRenewalRequirements_(_ value: LicenseRenewalRequirement)

    @objc(addLicenseRenewalRequirements_:)
    @NSManaged public func addToLicenseRenewalRequirements_(_ values: NSSet)

    @objc(removeLicenseRenewalRequirements_:)
    @NSManaged public func removeFromLicenseRenewalRequirements_(_ values: NSSet)

}

extension LicenseRenewal: Identifiable {

}
