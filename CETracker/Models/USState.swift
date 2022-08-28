//
//  USState.swift
//  CETracker
//
//  Created by Jon Onulak on 8/1/22.
//

import Foundation

enum USState: String, CaseIterable {
    case alabama = "AL", alaska = "AK", arizona = "AZ", arkansas = "AR", california = "CA", colorado = "CO", connecticut = "CT", districtOfColumbia = "DC", delaware = "DE", florida = "FL", georgia = "GA", hawaii = "HI", idaho = "ID", illinois = "IL", indiana = "IN", iowa = "IA", kansas = "KS", kentucky = "KY", louisiana = "LA", maine = "ME", maryland = "MD", massachusetts = "MA", michigan = "MI", minnesota = "MN", mississippi = "MS", missouri = "MO", montana = "MT", nebraska = "NE", nevada = "NV", newHampshire = "NH", newJersey = "NJ", newMexico = "NM", newYork = "NY", northCarolina = "NC", northDakota = "ND", ohio = "OH", oklahoma = "OK", oregon = "OR", pennsylvania = "PA", rhodeIsland = "RI", southCarolina = "SC", southDakota = "SD", tennessee = "TN", texas = "TX", utah = "UT", vermont = "VT", virginia = "VI", washington = "WA", westVirginia = "WV", wisconsin = "WI", wyoming = "WY"
    
    var stateName: String {
        var name: String = ""
        
        for char in String(describing: self) {
            if String(char) != String(char).uppercased() {
                name += String(char)
            } else {
                // add a space when we come to the camel-cased character
                name += " \(String(char))"
            }
        }
        
        return name.capitalized
    }
    
    static var allStateNames: [String] {
        return USState.allCases.map { $0.stateName }
    }
    
    static var allStateAbbreviations: [String] {
        return USState.allCases.map { $0.rawValue }
    }
    
    var renewalTerm: Int {
        switch self {
        case .alabama, .connecticut, .idaho, .kentucky, .louisiana, .maine, .montana, .newHampshire, .northCarolina, .oklahoma, .oregon, .rhodeIsland, .southCarolina, .southDakota, .virginia, .washington, .wyoming:
            return 1
        case .newYork, .ohio: return 3
        default: return 2
        }
    }
    
    var usesVariableRenewalYear: Bool {
        switch self {
        case .arizona:
            return true
        default: return false
        }
    }
    
    // MARK: - Renewal Requirements
    var creditRequirements: [RenewalRequirement] {
        return [
            termTotalCreditsRequirement,
            termLiveCreditsRequirement,
            termOpioidCreditsRequirements,
            termImmunizationCreditsRequirement,
            termLawCreditRequirement
        ].compactMap { $0 }
    }
    
    private var termTotalCreditsRequirement: RenewalRequirement {
        let totalRequiredCredits: Float
        switch self {
        case .southDakota, .wyoming: totalRequiredCredits = 12
        case .colorado: totalRequiredCredits = 24
        case .districtOfColumbia, .massachusetts: totalRequiredCredits = 40
        case .ohio: totalRequiredCredits = 60
        default: totalRequiredCredits = Float(renewalTerm) * 15
        }
        return RenewalRequirement(totalCredits: totalRequiredCredits)
    }
    
    
    private var termLiveCreditsRequirement: RenewalRequirement? {
        let totalRequiredCredits: Float
        switch self {
        case .maryland: totalRequiredCredits = 2
        case .louisiana: totalRequiredCredits = 3
        case .montana, .newHampshire, .rhodeIsland, .westVirginia: totalRequiredCredits = 5
        case .southCarolina, .alabama: totalRequiredCredits = 6
        case .northCarolina: totalRequiredCredits = 8
        case .connecticut, .districtOfColumbia, .florida, .massachusetts, .michigan, .newJersey, .newMexico, .vermont:
            totalRequiredCredits = 10
        case .arkansas, .utah: totalRequiredCredits = 12
        case .tennessee: totalRequiredCredits = 15
        case .newYork: totalRequiredCredits = 23
        default: return nil
        }
        return RenewalRequirement(liveCredits: totalRequiredCredits)
    }
    
    private var termImmunizationCreditsRequirement: RenewalRequirement? {
        // Always required for maine
        let totalReq: Float
        switch self {
        case .alaska, .hawaii, .iowa: totalReq = 1
        case .arizona, .districtOfColumbia, .delaware:
            totalReq = 2
        default: return nil
        }
        return RenewalRequirement(topicDesignator: .immunizations, creditsRequired: totalReq)
    }
    
    private var termOpioidCreditsRequirements: RenewalRequirement? {
        let totalReq: Float
        switch self {
        case .michigan: totalReq = 1
        case .delaware, .florida: totalReq = 2
        case .arizona: totalReq = 3
        case .mississippi: totalReq = 5
        default: return nil
        }
        return RenewalRequirement(topicDesignator: .painManagement, creditsRequired: totalReq)
    }
    
    private var termLawCreditRequirement: RenewalRequirement? {
        let totalRequiredCredits: Float
        switch self {
        case .connecticut, .idaho, .nevada, .oregon, .utah: totalRequiredCredits = 1
        case .iowa, .newMexico: totalRequiredCredits = 2
        case .arizona, .newJersey: totalRequiredCredits = 3
        case .massachusetts: totalRequiredCredits = 4
        default: return nil
        }
        return RenewalRequirement(topicDesignator: .law, creditsRequired: totalRequiredCredits)
    }
    
    private var miscCreditRequirements: [RenewalRequirement]? {
        switch self {
        case .delaware:
            return [
                RenewalRequirement(topicDesignator: .patientSafety, creditsRequired: 2)
            ]
        case .districtOfColumbia:
            return [
                RenewalRequirement(topicDesignator: .patientSafety, creditsRequired: 2),
                RenewalRequirement(topicDesignator: .AIDSHIVTherapy, creditsRequired: 2),
                RenewalRequirement(topicDesignator: .additional("Lesbian, gay, bisexual, transgender and queer or questioning (LGBTQ)"), creditsRequired: 2)
            ]
        case .florida:
            return [
                RenewalRequirement(topicDesignator: .additional("Human Trafficking"), creditsRequired: 1),
                RenewalRequirement(topicDesignator: .patientSafety, creditsRequired: 2)
            ]
        case .illinois:
            return [
                RenewalRequirement(topicDesignator: .additional("Sexual Harassment"), creditsRequired: 1)
            ]
        case .iowa:
            return [
                RenewalRequirement(topicDesignator: .diseaseStateManagementDrugTherapy, creditsRequired: 15),
                RenewalRequirement(topicDesignator: .patientSafety, creditsRequired: 2)
            ]
        case .kentucky:
            return [
                RenewalRequirement(topicDesignator: .AIDSHIVTherapy, creditsRequired: 1)
            ]
        case .maine:
            return [
                RenewalRequirement(topicDesignator: .immunizations, creditsRequired: 2)
            ]
        case .maryland:
            return [
                RenewalRequirement(topicDesignator: .patientSafety, creditsRequired: 1)
            ]
        case .michigan:
            return [
                RenewalRequirement(topicDesignator: .additional("Human Trafficking"), creditsRequired: 1)
            ]
//        case .mississippi:
//            return [
//                RenewalRequirement(topicDesignator: <#T##CETopicDesignator#>, creditsRequired: <#T##Float#>)
//            ]
        default: return nil
        }
    }
}
