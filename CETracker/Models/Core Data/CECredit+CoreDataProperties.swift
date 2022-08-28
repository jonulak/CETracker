//
//  CECredit+CoreDataProperties.swift
//  CETracker
//
//  Created by Jon Onulak on 8/1/22.
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
    @NSManaged public var renewals: NSSet?
    @NSManaged public var topicDesignator_: TopicDesignator?

}

// MARK: Generated accessors for renewals
extension CECredit {

    @objc(addRenewalsObject:)
    @NSManaged public func addToRenewals(_ value: LicenseRenewal)

    @objc(removeRenewalsObject:)
    @NSManaged public func removeFromRenewals(_ value: LicenseRenewal)

    @objc(addRenewals:)
    @NSManaged public func addToRenewals(_ values: NSSet)

    @objc(removeRenewals:)
    @NSManaged public func removeFromRenewals(_ values: NSSet)

}

extension CECredit : Identifiable {

}
