//
//  License+CoreDataClass.swift
//  CETracker
//
//  Created by Jon Onulak on 8/1/22.
//
//

import Foundation
import CoreData

@objc(License)
public class License: NSManagedObject {

    convenience init?(licenseInfo: LicenseInfo, context: NSManagedObjectContext) {
        guard let state = licenseInfo.state else { return nil }
        self.init(state: state, isImmunizer: licenseInfo.isImmunizer, periodStartDate: licenseInfo.startDate, periodEndDate: licenseInfo.endDate, context: context)
    }

    convenience init?(state: USState, isImmunizer: Bool, periodStartDate: Date, periodEndDate: Date, context: NSManagedObjectContext) {
        print("init license")
        // Prevent duplicates
        guard License.with(state: state, context: context) == nil else {
            return nil
        }

        self.init(entity: License.entity(), insertInto: context)

        self.state = state

        // Create first renewal
        let licenseRenewal = LicenseRenewal(state: state, isImmunizer: isImmunizer, periodStartDate: periodStartDate, periodEndDate: periodEndDate, context: context)
        licenseRenewal.license = self
    }

    static func fetchAll(context: NSManagedObjectContext) -> [License] {
        let request = License.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }

    static func with(state: USState, context: NSManagedObjectContext) -> License? {
        let request = License.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K == %@",
            NSExpression(forKeyPath: \License.state_).keyPath,
            state.rawValue
        )
        return try? context.fetch(request).first
    }

    func addCredits(credits: [CECredit]) {
        let isImmunizer = renewals.first?.isImmunizer ?? false
        let stateRequirements = state.getCreditRequirements(isImmunizer: isImmunizer)
        var creditSet = Set(credits)
        for renewal in renewals {
            if creditSet.isEmpty { return }
            let periodCredits = creditSet.filter { $0.date <= renewal.periodEndDate && $0.date >= renewal.periodStartDate }
            periodCredits.forEach { creditSet.remove($0) }
            renewal.addCredits(credits: periodCredits, stateRequirements: stateRequirements)
        }
    }

    var state: USState {
        get { USState(rawValue: state_!)! }
        set { state_ = newValue.rawValue }
    }

    var renewals: [LicenseRenewal] {
        get {
            renewals_.sorted { $0.periodEndDate > $1.periodEndDate }
        }
        set {
            renewals_ = Set(newValue)
        }
    }

}
