//
//  LicenseInfo.swift
//  CETracker
//
//  Created by Jon Onulak on 9/8/22.
//

import Foundation

struct LicenseInfo {
    var licenseNumber: String = ""
    var isImmunizer: Bool = false

    var state: USState? {
        didSet {
            guard let state = state else { return }
            endDate = state.nextExpirationDate
            startDate = Calendar.current.date(byAdding: .day, value: -(state.renewalTermLengthInYears * 365) + 1, to: endDate) ?? Date.now
        }
    }

    var startDate: Date = Calendar.current.date(byAdding: .year, value: -2, to: Date.now)!

    var endDate: Date = Date.now

}
