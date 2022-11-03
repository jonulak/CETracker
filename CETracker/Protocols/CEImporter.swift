//
//  CEImporter.swift
//  CETracker
//
//  Created by Jon Onulak on 7/25/22.
//

import Foundation
import CoreData
import UIKit

protocol CEImporter {
    func importCE(context: NSManagedObjectContext) async throws -> [CECredit]
    var configViewController: CEImporterConfigViewController { get }
}
