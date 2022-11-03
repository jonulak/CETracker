//
//  CELogViewModel.swift
//  CETracker
//
//  Created by Jon Onulak on 7/29/22.
//

import Foundation
import UIKit

class CELogViewModel: ObservableObject {
    @Published private var model: CELogModel

    var credits: [CECredit] { model.credits }

    init(model: CELogModel) {
        self.model = model
    }

    func importCE(from importer: CEImporter) async throws -> TableViewChange {
        return try await model.importCredits(from: importer)
    }

    func hoursLabel(for credit: CECredit) -> String {
        "Hours: " + String(credit.totalHours) + (credit.liveHours > 0 ? " (Live)" : "")
    }

    func dateLabel(for credit: CECredit) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = credit.date
        return dateFormatter.string(from: date)
    }

    func clearCredits() -> TableViewChange {
        return model.clearCredits()
    }

    func getCellColorFor(topic: CETopicDesignator) -> UIColor {
        let color: UIColor
        switch topic {
        case .diseaseStateManagementDrugTherapy:
            color = .systemTeal
        case .AIDSHIVTherapy:
            color = .systemCyan
        case .law:
            color = .systemBlue
        case .pharmacyAdministration:
            color = .systemGray
        case .patientSafety:
            color = .systemBrown
        case .immunizations:
            color = .systemGreen
        case .compounding:
            color = .systemIndigo
        case .painManagement:
            color = .systemRed
        case .additional:
            color = .darkGray
        }
        return color
    }

}
