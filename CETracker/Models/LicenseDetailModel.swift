//
//  LicenseDetailModel.swift
//  CETracker
//
//  Created by Jon Onulak on 9/18/22.
//

import Foundation

struct LicenseDetailModel {
    let license: License

    init(license: License) {
        self.license = license
    }

    func getRenewalRequirements(for renewal: LicenseRenewal) -> [LicenseRenewalRequirement] {
        renewal.licenseRenewalRequirements
    }

}
