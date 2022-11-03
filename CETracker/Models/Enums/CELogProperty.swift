//
//  CEProperty.swift
//  CETracker
//
//  Created by Jon Onulak on 7/24/22.
//

import Foundation

enum CELogProperty: CaseIterable {
    case date, UAN, creditType, source, title, provider, topicDesignators, liveHours, homeHours

    init?(string: String) {
        switch string {
        case "Activity Date": self = .date
        case "ACPE UAN": self = .UAN
        case "CreditType": self = .creditType
        case "Source": self = .source
        case "Title": self = .title
        case "Provider": self = .provider
        case "Topic Designators": self = .topicDesignators
        case "Live Hours": self = .liveHours
        case "Home Hours": self = .homeHours
        default: return nil
        }
    }
}
