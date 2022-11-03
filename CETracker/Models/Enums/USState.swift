//
//  USState.swift
//  CETracker
//
//  Created by Jon Onulak on 8/1/22.
//

import Foundation

enum USState: String, CaseIterable {
    private enum ExpirationDay: Equatable {
        case first
        case last
        case other(Int)
        case variable
    }

    private enum ExpirationMonth: Equatable {
        case scheduled(Int)
        case variable
    }

    private enum ExpirationYear: Equatable {
        case scheduled(Int)
        case variable
    }

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

    // MARK: - Renewal Dates
    var renewalTermLengthInYears: Int {
        switch self {
        case .alabama, .connecticut, .idaho, .kentucky, .louisiana, .maine, .mississippi, .montana, .newHampshire, .northCarolina, .northDakota, .oklahoma, .rhodeIsland, .southCarolina, .southDakota, .virginia, .washington, .wyoming:
            return 1
        case .newYork: return 3
        default: return 2
        }
    }

    var nextExpirationDate: Date {
        var dateComponents = DateComponents()
        let expYear = expirationYear != .variable ? expirationYear : .scheduled(Calendar.current.component(.year, from: Date.now))
        let expMonth = expirationMonth != .variable ? expirationMonth : .scheduled(12)
        guard case .scheduled(let expYearInt) = expYear else { return Date.now }
        guard case .scheduled(var expMonthInt) = expMonth else {  return Date.now }
        let expDayInt: Int
        switch expirationDay {
        case .first:
            expDayInt = 1
        case .last, .variable:
            expMonthInt += 1
            expDayInt = 0
        case .other(let dayInt):
            expDayInt = dayInt
        }
        dateComponents.year = expYearInt
        dateComponents.month = expMonthInt
        dateComponents.day = expDayInt
        print(expYearInt, expMonthInt, expDayInt)
        return Calendar.current.date(from: dateComponents) ?? Date.now
    }

    private var expirationYear: ExpirationYear {
        switch self {
        case .arizona, .arkansas, .idaho, .kansas, .maryland, .michigan, .newMexico, .tennessee, .texas:
            return .variable
        case let state where state.renewalTermLengthInYears > 2:
            var year = baseRenewalYear
            let currentYear = Calendar.current.component(.year, from: Date.now)
            while year < currentYear {
                year += renewalTermLengthInYears
            }
            return .scheduled(year)
        case let state where state.renewalTermLengthInYears == 2:
            let remainder = isEvenYearRenewal ? 0 : 1
            let currentYear = Calendar.current.component(.year, from: Date())
            return currentYear % 2 == remainder ? .scheduled(currentYear) : .scheduled(currentYear + 1)
        case let state where state.renewalTermLengthInYears == 1:
            let licenseExpirationMonth = expirationMonth != .variable ? expirationMonth : .scheduled(12)
            let currentMonth = Calendar.current.component(.month, from: Date.now)
            let currentYear = Calendar.current.component(.year, from: Date.now)
            guard case .scheduled(let expMonthInt) = licenseExpirationMonth else {
                return .scheduled(currentYear)
            }
            let expYear = currentMonth <= expMonthInt ? currentYear : currentYear + 1
            return .scheduled(expYear)
        default:
            return .variable
        }
    }

    // Only used if renewal period is > 2 years
    private var baseRenewalYear: Int {
        switch self {
        case .newYork:
            return 2022
        default:
            return 1900
        }
    }

    // Only used for 2 year renewal cycle
    private var isEvenYearRenewal: Bool {
        switch self {
        case .alabama, .alaska, .california, .connecticut, .delaware, .georgia,
                .illinois, .indiana, .iowa, .massachusetts, .minnesota, .missouri,
                .nebraska, .newHampshire, .pennsylvania, .westVirginia, .wisconsin:
            return true
        default:
            return false
        }
    }

    private var expirationMonth: ExpirationMonth {
        switch self {
        case .california, .maryland, .michigan, .newMexico, .newYork, .oklahoma, .tennessee, .texas, .washington:
            return .variable
        case .connecticut, .nebraska:
            return .scheduled(1)
        case .districtOfColumbia, .kentucky:
            return .scheduled(2)
        case .illinois, .northDakota:
            return .scheduled(3)
        case .newJersey:
            return .scheduled(4)
        case .wisconsin:
            return .scheduled(5)
        case .alaska, .indiana, .iowa, .kansas, .montana, .rhodeIsland, .westVirginia:
            return .scheduled(6)
        case .oregon, .vermont:
            return .scheduled(7)
        case .delaware, .florida, .minnesota, .pennsylvania, .southCarolina, .southDakota, .utah:
            return .scheduled(9)
        case .arizona, .colorado, .missouri, .nevada:
            return .scheduled(10)
        default:
            return .scheduled(12)
        }
    }

    private var expirationDay: ExpirationDay {
        switch self {
        case .nebraska, .northDakota, .oregon:
            return .first
        case .ohio:
            return .other(15)
        case .washington:
            return .variable
        default:
            return .last
        }
    }

    // MARK: - Renewal Requirements
    private var termTotalCreditsRequirement: StateRenewalRequirement {
        let totalRequiredCredits: Float
        switch self {
        case .southDakota, .wyoming: totalRequiredCredits = 12
        case .montana: totalRequiredCredits = 20
        case .colorado: totalRequiredCredits = 24
        case .districtOfColumbia, .massachusetts, .ohio: totalRequiredCredits = 40
        default: totalRequiredCredits = Float(renewalTermLengthInYears) * 15
        }
        return StateRenewalRequirement(totalCredits: totalRequiredCredits)
    }

    private var termLiveCreditsRequirement: StateRenewalRequirement? {
        let totalRequiredCredits: Float
        switch self {
        case .maryland, .mississippi: totalRequiredCredits = 2
        case .louisiana, .virginia: totalRequiredCredits = 3
        case .montana, .northCarolina, .rhodeIsland: totalRequiredCredits = 5
        case .southCarolina, .alabama, .westVirginia: totalRequiredCredits = 6
        case .connecticut, .districtOfColumbia, .florida, .massachusetts, .michigan, .newHampshire, .newJersey, .newMexico, .vermont:
            totalRequiredCredits = 10
        case .arkansas, .utah: totalRequiredCredits = 12
        case .tennessee: totalRequiredCredits = 15
        case .newYork: totalRequiredCredits = 23
        default: return nil
        }
        return StateRenewalRequirement(liveCredits: totalRequiredCredits)
    }

    private var termImmunizationCreditsRequirement: StateRenewalRequirement? {
        // Always required for maine
        let totalReq: Float
        switch self {
        case .alaska, .hawaii, .iowa, .massachusetts, .southCarolina:
            totalReq = 1
        case .arizona, .districtOfColumbia, .delaware, .missouri, .nevada, .newJersey, .pennsylvania:
            totalReq = 2
        case .northCarolina:
            totalReq = 3
        default: return nil
        }
        return StateRenewalRequirement(topicDesignator: .immunizations, creditsRequired: totalReq)
    }

    @RenewalRequirementsBuilder
    func getCreditRequirements(isImmunizer: Bool) -> [StateRenewalRequirement] {
        termTotalCreditsRequirement
        if let liveCredits = termLiveCreditsRequirement { liveCredits }
        if isImmunizer, let immunizationCredits = termImmunizationCreditsRequirement { immunizationCredits }
        switch self {
        case .arizona:
            StateRenewalRequirement(topicDesignator: .law, creditsRequired: 3)
            StateRenewalRequirement(topicDesignator: .painManagement, creditsRequired: 3)
        case .connecticut:
            StateRenewalRequirement(topicDesignator: .law, creditsRequired: 1)
        case .districtOfColumbia:
            StateRenewalRequirement(topicDesignator: .AIDSHIVTherapy, creditsRequired: 2)
            StateRenewalRequirement(topicDesignator: .patientSafety, creditsRequired: 2)
            StateRenewalRequirement(topicDesignator: .additional("Lesbian, gay, bisexual, transgender and queer or questioning (LGBTQ)"), creditsRequired: 2)
        case .delaware:
            StateRenewalRequirement(topicDesignator: .patientSafety, creditsRequired: 2)
            StateRenewalRequirement(topicDesignator: .painManagement, creditsRequired: 2)
        case .florida:
            StateRenewalRequirement(topicDesignator: .patientSafety, creditsRequired: 2)
            StateRenewalRequirement(topicDesignator: .painManagement, creditsRequired: 2)
        case .illinois:
            StateRenewalRequirement(topicDesignator: .additional("Sexual Harassment"), creditsRequired: 1)
        case .iowa:
            StateRenewalRequirement(topicDesignator: .law, creditsRequired: 2)
            StateRenewalRequirement(topicDesignator: .diseaseStateManagementDrugTherapy, creditsRequired: 15)
            StateRenewalRequirement(topicDesignator: .patientSafety, creditsRequired: 2)
        case .maine:
            StateRenewalRequirement(title: "Drug Administration", creditsRequired: 2) { _ in false }
        case .maryland:
            StateRenewalRequirement(topicDesignator: .patientSafety, creditsRequired: 1)
        case .massachusetts:
            StateRenewalRequirement(topicDesignator: .law, creditsRequired: 4)
        case .michigan:
            StateRenewalRequirement(topicDesignator: .painManagement, creditsRequired: 1)
            StateRenewalRequirement(topicDesignator: .additional("Human Trafficking"), creditsRequired: 1)
        case .mississippi:
            StateRenewalRequirement(topicDesignator: .painManagement, creditsRequired: 5)
        case .nevada:
            StateRenewalRequirement(topicDesignator: .law, creditsRequired: 1)
        case .newJersey:
            StateRenewalRequirement(topicDesignator: .law, creditsRequired: 3)
            StateRenewalRequirement(topicDesignator: .painManagement, creditsRequired: 1)
        case .newMexico:
            StateRenewalRequirement(topicDesignator: .law, creditsRequired: 2)
            StateRenewalRequirement(topicDesignator: .patientSafety, creditsRequired: 2)
            StateRenewalRequirement(topicDesignator: .painManagement, creditsRequired: 2)
        case .newYork:
            StateRenewalRequirement(topicDesignator: .patientSafety, creditsRequired: 3)
        case .ohio:
            StateRenewalRequirement(topicDesignator: .law, creditsRequired: 2)
            StateRenewalRequirement(topicDesignator: .patientSafety, creditsRequired: 2)
        case .oregon:
            StateRenewalRequirement(topicDesignator: .law, creditsRequired: 2)
            StateRenewalRequirement(topicDesignator: .patientSafety, creditsRequired: 2)
        case .pennsylvania:
            StateRenewalRequirement(topicDesignator: .patientSafety, creditsRequired: 2)
            StateRenewalRequirement(topicDesignator: .painManagement, creditsRequired: 2)
            StateRenewalRequirement(topicDesignator: .additional("Child Abuse Prevention or Reporting"), creditsRequired: 2)
        case .rhodeIsland:
            StateRenewalRequirement(topicDesignator: .law, creditsRequired: 1)
        case .southCarolina:
            StateRenewalRequirement(topicDesignators: [.diseaseStateManagementDrugTherapy, .patientSafety], creditsRequired: 7.5)
            StateRenewalRequirement(topicDesignator: .painManagement, creditsRequired: 1)
        case .texas:
            StateRenewalRequirement(topicDesignator: .law, creditsRequired: 1)
            StateRenewalRequirement(topicDesignator: .painManagement, creditsRequired: 2)
//            StateRenewalRequirement(topicDesignator: .additional("Human Trafficking"), creditsRequired: 1)
        case .utah:
            StateRenewalRequirement(topicDesignator: .law, creditsRequired: 1)
            StateRenewalRequirement(topicDesignators:
                                        [
                                            .diseaseStateManagementDrugTherapy,
                                            .AIDSHIVTherapy,
                                            .pharmacyAdministration,
                                            .patientSafety,
                                            .immunizations
                                        ],
                                    creditsRequired: 15)
        case .washington:
            StateRenewalRequirement(topicDesignator: .additional("Suicide Prevention"), creditsRequired: 1)
        case .westVirginia:
            StateRenewalRequirement(title: "Drug Diversion", creditsRequired: 3, creditIsValid: {_ in false})
        default:
            [StateRenewalRequirement]()
        }
    }
}
