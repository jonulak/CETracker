//
//  RenewalRequirement.swift
//  CETracker
//
//  Created by Jon Onulak on 8/8/22.
//

import Foundation

struct RenewalRequirement {
    var title: String
    var creditsRequired: Float
    var creditIsValid: (_ credit: CECredit) -> Bool
    
    init(title: String, creditsRequired: Float, creditIsValid: @escaping (_ credit: CECredit) -> Bool) {
        self.title = title
        self.creditsRequired = creditsRequired
        self.creditIsValid = creditIsValid
    }
    
    init(totalCredits: Float) {
        self.title = "Total"
        self.creditsRequired = totalCredits
        self.creditIsValid = { _ in true }
    }
    
    init(liveCredits: Float) {
        self.title = "Live"
        self.creditsRequired = liveCredits
        self.creditIsValid = { credit in credit.liveHours > 0 }
    }
    
    init(topicDesignator: CETopicDesignator, creditsRequired: Float) {
        self.title = topicDesignator.topicDesignatorTitle
        self.creditsRequired = creditsRequired
        self.creditIsValid = { credit in credit.topicDesignator == topicDesignator }
    }
    
    init(topicDesignators: [CETopicDesignator], creditsRequired: Float) {
        self.title = topicDesignators.map { $0.topicDesignatorTitle }.joined(separator: "/")
        self.creditsRequired = creditsRequired
        self.creditIsValid = { credit in topicDesignators.contains(credit.topicDesignator) }
    }
}
