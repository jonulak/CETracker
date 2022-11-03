//
//  NumberFormatter+CETrackerCreditHourFormatter.swift
//  CETracker
//
//  Created by Jon Onulak on 9/22/22.
//

import Foundation

extension NumberFormatter {
    static var CETrackerNumberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }
}
