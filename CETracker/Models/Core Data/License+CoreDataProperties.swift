//
//  License+CoreDataProperties.swift
//  CETracker
//
//  Created by Jon Onulak on 9/1/22.
//
//

import Foundation
import CoreData

extension License {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<License> {
        return NSFetchRequest<License>(entityName: "License")
    }

    @NSManaged public var licenseNumber: String?
    @NSManaged public var state_: String?
    @NSManaged public var renewals_: Set<LicenseRenewal>

}

// MARK: Generated accessors for renewals_
extension License {

    @objc(addRenewals_Object:)
    @NSManaged public func addToRenewals_(_ value: LicenseRenewal)

    @objc(removeRenewals_Object:)
    @NSManaged public func removeFromRenewals_(_ value: LicenseRenewal)

    @objc(addRenewals_:)
    @NSManaged public func addToRenewals_(_ values: NSSet)

    @objc(removeRenewals_:)
    @NSManaged public func removeFromRenewals_(_ values: NSSet)

}

extension License: Identifiable {

}
