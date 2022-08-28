//
//  LicenseRenewal+CoreDataProperties.swift
//  CETracker
//
//  Created by Jon Onulak on 8/1/22.
//
//

import Foundation
import CoreData


extension LicenseRenewal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LicenseRenewal> {
        return NSFetchRequest<LicenseRenewal>(entityName: "LicenseRenewal")
    }

    @NSManaged public var renewalDate_: Date?
    @NSManaged public var status_: String?
    @NSManaged public var license: License
    @NSManaged public var credits: Set<CECredit>

}

// MARK: Generated accessors for credits
extension LicenseRenewal {

    @objc(addCreditsObject:)
    @NSManaged public func addToCredits(_ value: CECredit)

    @objc(removeCreditsObject:)
    @NSManaged public func removeFromCredits(_ value: CECredit)

    @objc(addCredits:)
    @NSManaged public func addToCredits(_ values: NSSet)

    @objc(removeCredits:)
    @NSManaged public func removeFromCredits(_ values: NSSet)

}

extension LicenseRenewal : Identifiable {

}
