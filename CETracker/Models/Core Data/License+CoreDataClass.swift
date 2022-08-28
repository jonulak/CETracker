//
//  License+CoreDataClass.swift
//  CETracker
//
//  Created by Jon Onulak on 8/1/22.
//
//

import Foundation
import CoreData

@objc(License)
public class License: NSManagedObject {
    
    static func fetchAll(context: NSManagedObjectContext) -> [License] {
        let request = License.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }
    
    static func with(state: USState, context: NSManagedObjectContext) -> License? {
        let request = License.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K == %@",
            NSExpression(forKeyPath: \License.state_).keyPath,
            state.rawValue
        )
        return try? context.fetch(request).first
    }

    var state: USState {
        get { USState(rawValue: state_!)! }
        set { state_ = newValue.rawValue }
    }
    
}
