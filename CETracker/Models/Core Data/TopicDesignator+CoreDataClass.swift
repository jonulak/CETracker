//
//  TopicDesignator+CoreDataClass.swift
//  CETracker
//
//  Created by Jon Onulak on 7/24/22.
//
//

import Foundation
import CoreData

@objc(TopicDesignator)
public class TopicDesignator: NSManagedObject {
    
    var code: String {
        get { code_! }
        set { code_ = newValue }
    }
    
    var title: String {
        get { title_! }
        set { title_ = newValue }
    }
    
    static func from(_ enumTopicDesignator: CETopicDesignator, context: NSManagedObjectContext) -> TopicDesignator {
        return with(
            code: enumTopicDesignator.topicDesignatorCode,
            title: enumTopicDesignator.topicDesignatorTitle,
            context: context
        )
    }
    
    static func with(code: String, title: String, context: NSManagedObjectContext) -> TopicDesignator {
        let request = NSFetchRequest<Self>(entityName: String(describing: Self.self))
        request.predicate = NSPredicate(
            format: "%K == %@ && %K == %@",
            NSExpression(forKeyPath: \TopicDesignator.code_).keyPath, code,
            NSExpression(forKeyPath: \TopicDesignator.title_).keyPath, title
        )
        if let topicDesignator = try? context.fetch(request).first { return topicDesignator }
        let topicDesignator = TopicDesignator(context: context)
        topicDesignator.title_ = title
        topicDesignator.code_ = code
        return topicDesignator
    }

}
