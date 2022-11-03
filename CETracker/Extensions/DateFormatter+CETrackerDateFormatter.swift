//
//  DateFormatter+CETrackerDateFormatter.swift
//  CETracker
//
//  Created by Jon Onulak on 9/18/22.
//

import Foundation

extension DateFormatter {
    static var CETrackerDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }
}
