//
//  CELogModel.swift
//  CETracker
//
//  Created by Jon Onulak on 7/29/22.
//

import Foundation
import CoreData

class CELogModel: ObservableObject {
    @Published var credits: [CECredit]
    var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        credits = CECredit.fetchAll(context: context)
        credits = sortCredits(credits: credits)
    }

    func importCredits(from importer: CEImporter) async throws -> TableViewChange {
        let childContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        childContext.parent = context
        let newCredits = try await importer.importCE(context: childContext)
        let licenses = License.fetchAll(context: childContext)
        licenses.forEach { $0.addCredits(credits: newCredits) }
        try childContext.save()
        try context.save()
        let objectIDs = newCredits.map { $0.objectID }
        let mainQueueCredits = objectIDs.compactMap { context.object(with: $0) as? CECredit }
        let sortedCredits = sortCredits(credits: mainQueueCredits)
        credits.insert(contentsOf: sortedCredits, at: 0)
        let indexPaths = (0..<sortedCredits.count).map { IndexPath(row: $0, section: 0) }
        return (.addition, indexPaths)
    }

    func sortCredits(credits: [CECredit]) -> [CECredit] {
        return credits.sorted { $0.date > $1.date }
    }

    func clearCredits() -> TableViewChange {
        let indexPaths = (0..<credits.count).map { IndexPath(row: $0, section: 0) }
        credits.forEach { context.delete($0) }
        credits.removeAll()
        try? context.save()
        return (.deletion, indexPaths)
    }
}
