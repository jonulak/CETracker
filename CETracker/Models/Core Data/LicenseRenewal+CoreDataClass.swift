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
    
    var renewalDate: Date {
        get { renewalDate_! }
        set { renewalDate_ = newValue }
    }
    
    var status: LicenseRenewalStatus {
        get { LicenseRenewalStatus(rawValue: status_!)! }
        set { status_ = newValue.rawValue }
    }
    
}
