//
//  RenewalRequirementsBuilder.swift
//  CETracker
//
//  Created by Jon Onulak on 9/10/22.
//

import Foundation

protocol RequirementGroup {
    var requirements: [StateRenewalRequirement] { get }
}

extension StateRenewalRequirement: RequirementGroup {
    var requirements: [StateRenewalRequirement] { [self] }
}

extension Array: RequirementGroup where Element == StateRenewalRequirement {
    var requirements: [StateRenewalRequirement] { self }
}

@resultBuilder
struct RenewalRequirementsBuilder {
    static func buildBlock(_ components: RequirementGroup...) -> [StateRenewalRequirement] {
        return components.flatMap { $0.requirements }
    }

    static func buildOptional(_ component: [RequirementGroup]?) -> [StateRenewalRequirement] {
        component?.flatMap { $0.requirements } ?? []
    }

    static func buildEither(first component: [RequirementGroup]) -> [StateRenewalRequirement] {
        component.flatMap { $0.requirements }
    }

    static func buildEither(second component: [RequirementGroup]) -> [StateRenewalRequirement] {
        component.flatMap { $0.requirements }
    }
}
