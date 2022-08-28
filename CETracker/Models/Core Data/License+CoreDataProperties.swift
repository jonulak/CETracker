//
//  License+CoreDataProperties.swift
//  CETracker
//
//  Created by Jon Onulak on 8/1/22.
//
//

import Foundation
import CoreData


extension License {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<License> {
        return NSFetchRequest<License>(entityName: "License")
    }

    @NSManaged public var state_: String?
    @NSManaged public var licenseNumber: String?
    @NSManaged public var renewals: Set<LicenseRenewal>

}

// MARK: Generated accessors for renewals
extension License {

    @objc(addRenewalsObject:)
    @NSManaged public func addToRenewals(_ value: LicenseRenewal)

    @objc(removeRenewalsObject:)
    @NSManaged public func removeFromRenewals(_ value: LicenseRenewal)

    @objc(addRenewals:)
    @NSManaged public func addToRenewals(_ values: NSSet)

    @objc(removeRenewals:)
    @NSManaged public func removeFromRenewals(_ values: NSSet)

}

extension License : Identifiable {

}
