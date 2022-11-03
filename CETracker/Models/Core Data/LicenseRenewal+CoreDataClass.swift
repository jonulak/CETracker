//
//  LicenseRenewal+CoreDataClass.swift
//  CETracker
//
//  Created by Jon Onulak on 8/1/22.
//
//

import Foundation
import CoreData

@objc(LicenseRenewal)
public class LicenseRenewal: NSManagedObject {

    convenience init(state: USState, isImmunizer: Bool, periodStartDate: Date, periodEndDate: Date, context: NSManagedObjectContext) {
        print("init renewal")
        self.init(entity: LicenseRenewal.entity(), insertInto: context)
        self.periodStartDate = periodStartDate
        self.periodEndDate = periodEndDate
        self.isImmunizer = isImmunizer
        self.status = .notSubmitted

        let periodCredits = CECredit.from(periodStartDate, to: periodEndDate, context: context)
        let requirements = state.getCreditRequirements(isImmunizer: isImmunizer)
        var renewalPeriodRequirements = Set<LicenseRenewalRequirement>()

        for requirement in requirements {
            let applicableCEs = periodCredits.filter { requirement.creditIsValid($0) }
            let renewalRequirement = LicenseRenewalRequirement(title: requirement.title,
                                                               creditsRequired: requirement.creditsRequired,
                                                               credits: applicableCEs,
                                                               context: context)
            renewalPeriodRequirements.insert(renewalRequirement)
        }
        renewalPeriodRequirements.forEach { $0.licenseRenewal = self }
    }

    func addCredits(credits: Set<CECredit>, stateRequirements: [StateRenewalRequirement]) {
        if credits.isEmpty { return }
        for stateRequirement in stateRequirements {
            let applicableCEs = credits.filter { stateRequirement.creditIsValid($0) }
            if !applicableCEs.isEmpty {
                guard let renewalRequirement = licenseRenewalRequirements.filter({ $0.title == stateRequirement.title }).first else { continue }
                renewalRequirement.addToAppliedCredits(applicableCEs as NSSet)
            }
        }
    }

    var status: LicenseRenewalStatus {
        get { LicenseRenewalStatus(rawValue: status_!)! }
        set { status_ = newValue.rawValue }
    }

    var periodEndDate: Date {
        get { periodEndDate_! }
        set { periodEndDate_ = newValue }
    }

    var periodStartDate: Date {
        get { periodStartDate_! }
        set { periodStartDate_ = newValue }
    }

    var licenseRenewalRequirements: [LicenseRenewalRequirement] {
        get { licenseRenewalRequirements_.sorted { first, second in
            if first.creditsRequired == second.creditsRequired {
                return first.title < second.title
            }
            return first.creditsRequired > second.creditsRequired
        } }
        set { licenseRenewalRequirements_ = Set(newValue) }
    }

}
