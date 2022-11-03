//
//  CECredit+CoreDataProperties.swift
//  CETracker
//
//  Created by Jon Onulak on 8/31/22.
//
//

import Foundation
import CoreData

extension CECredit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CECredit> {
        return NSFetchRequest<CECredit>(entityName: "CECredit")
    }

    @NSManaged public var creditType_: String?
    @NSManaged public var date_: Date?
    @NSManaged public var homeHours: Float
    @NSManaged public var liveHours: Float
    @NSManaged public var provider_: String?
    @NSManaged public var source_: String?
    @NSManaged public var title_: String?
    @NSManaged public var uan_: String?
    @NSManaged public var licenseRequirementsApplied: Set<LicenseRenewalRequirement>
    @NSManaged public var topicDesignator_: TopicDesignator?

}

// MARK: Generated accessors for licenseRequirementsApplied
extension CECredit {

    @objc(addLicenseRequirementsAppliedObject:)
    @NSManaged public func addToLicenseRequirementsApplied(_ value: LicenseRenewalRequirement)

    @objc(removeLicenseRequirementsAppliedObject:)
    @NSManaged public func removeFromLicenseRequirementsApplied(_ value: LicenseRenewalRequirement)

    @objc(addLicenseRequirementsApplied:)
    @NSManaged public func addToLicenseRequirementsApplied(_ values: NSSet)

    @objc(removeLicenseRequirementsApplied:)
    @NSManaged public func removeFromLicenseRequirementsApplied(_ values: NSSet)

}

extension CECredit: Identifiable {

}
