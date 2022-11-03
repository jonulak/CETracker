//
//  TopicDesignator+CoreDataProperties.swift
//  CETracker
//
//  Created by Jon Onulak on 8/31/22.
//
//

import Foundation
import CoreData

extension TopicDesignator {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TopicDesignator> {
        return NSFetchRequest<TopicDesignator>(entityName: "TopicDesignator")
    }

    @NSManaged public var code_: String?
    @NSManaged public var title_: String?
    @NSManaged public var credits: Set<CECredit>

}

// MARK: Generated accessors for credits
extension TopicDesignator {

    @objc(addCreditsObject:)
    @NSManaged public func addToCredits(_ value: CECredit)

    @objc(removeCreditsObject:)
    @NSManaged public func removeFromCredits(_ value: CECredit)

    @objc(addCredits:)
    @NSManaged public func addToCredits(_ values: NSSet)

    @objc(removeCredits:)
    @NSManaged public func removeFromCredits(_ values: NSSet)

}

extension TopicDesignator: Identifiable {

}
