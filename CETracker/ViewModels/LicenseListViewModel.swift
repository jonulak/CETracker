//
//  LicenseListViewModel.swift
//  CETracker
//
//  Created by Jon Onulak on 8/1/22.
//

import Foundation
import CoreData
import Combine

class LicenseListViewModel: ObservableObject {
    
    @Published private var licenseListModel: LicenseListModel
    var context: NSManagedObjectContext
    
    var licenses: [License] { licenseListModel.licenses }
    var cancellables = Set<AnyCancellable>()
    
    init(context: NSManagedObjectContext) {
        licenseListModel = LicenseListModel(context: context)
        self.context = context
    }
    
    func addLicense(for state: USState) -> TableViewChange? {
        return licenseListModel.addLicense(for: state)
    }
    
    func getValidCreditsFor(state: USState) -> [CECredit] {
        // TODO:  Date filtering for renewal period
        return CECredit.fetchAll(context: context)
    }
    
}
