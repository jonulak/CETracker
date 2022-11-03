//
//  LicenseDetailViewModel.swift
//  CETracker
//
//  Created by Jon Onulak on 9/18/22.
//

import Foundation

class LicenseDetailViewModel {

    var model: LicenseDetailModel

    init(licenseDetailModel: LicenseDetailModel) {
        model = licenseDetailModel
    }

    var license: License { model.license }
    var renewals: [LicenseRenewal] { model.license.renewals }

    func getRenewalRequirements(for renewal: LicenseRenewal) -> [LicenseRenewalRequirement] {
        model.getRenewalRequirements(for: renewal)
    }

}
