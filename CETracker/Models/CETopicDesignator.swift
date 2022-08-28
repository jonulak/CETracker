//
//  CETopicDesignator.swift
//  CETracker
//
//  Created by Jon Onulak on 7/24/22.
//

import Foundation

enum CETopicDesignator: Equatable {
    case diseaseStateManagementDrugTherapy, AIDSHIVTherapy, law, pharmacyAdministration, patientSafety, immunizations, compounding, painManagement, additional(String)
    
    init(string: String) {
        switch string {
        case "Disease State Mgmt/Drug Therapy": self = .diseaseStateManagementDrugTherapy
        case "AIDS/HIV Therapy": self = .AIDSHIVTherapy
        case "Law (Related to Pharm)": self = .law
        case "Pharmacy Administration": self = .pharmacyAdministration
        case "Patient Safety": self = .patientSafety
        case "Immunizations": self = .immunizations
        case "Compounding": self = .compounding
        case "Pain Management": self = .painManagement
        default: self = .additional(string)
        }
    }
    
    init?(topicDesignatorCode: String, topicString: String) {
        switch topicDesignatorCode {
        case "01": self = .diseaseStateManagementDrugTherapy
        case "02": self = .AIDSHIVTherapy
        case "03": self = .law
        case "04": self = .pharmacyAdministration
        case "05": self = .patientSafety
        case "06": self = .immunizations
        case "07": self = .compounding
        case "08": self = .painManagement
        case "99": self = .additional(topicString)
        default: return nil
        }
    }
    
    var topicDesignatorCode: String {
        switch self {
        case .diseaseStateManagementDrugTherapy: return "01"
        case .AIDSHIVTherapy: return "02"
        case .law: return "03"
        case .pharmacyAdministration: return "04"
        case .patientSafety: return "05"
        case .immunizations: return "06"
        case .compounding: return "07"
        case .painManagement: return "08"
        case .additional: return "99"
        }
    }
    
    var topicDesignatorTitle: String {
        switch self {
        case .AIDSHIVTherapy: return "AIDS/HIV Therapy"
        case .law: return "Law (Related to Pharm)"
        case .pharmacyAdministration: return "Pharmacy Administration"
        case .patientSafety: return "Patient Safety"
        case .immunizations: return "Immunizations"
        case .compounding: return "Compounding"
        case .painManagement: return "Pain Management"
        case .diseaseStateManagementDrugTherapy: return "Disease State Mgmt/Drug Therapy"
        case .additional(let title): return "\(title)"
        }
    }
}
