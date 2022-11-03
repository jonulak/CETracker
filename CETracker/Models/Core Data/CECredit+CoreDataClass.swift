//
//  CECredit+CoreDataClass.swift
//  CETracker
//
//  Created by Jon Onulak on 7/24/22.
//
//

import Foundation
import CoreData

enum CECreditError: Error {
    case missingProperty(CELogProperty)
    case invalidTopicDesignator
    case invalidDate
}

@objc(CECredit)
public class CECredit: NSManagedObject {

    static func getTopicDesignatorCode(UAN: String) -> String {
        let splitUAN = UAN.split(separator: "-")
        let code = splitUAN[4].dropFirst()
        return String(code)
    }

    static func with(UAN: String, context: NSManagedObjectContext) -> CECredit? {
        let request = CECredit.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K == %@",
            NSExpression(forKeyPath: \CECredit.uan_).keyPath, UAN
        )
        return try? context.fetch(request).first
    }

    static func fetchAll(context: NSManagedObjectContext) -> [CECredit] {
        let request = CECredit.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }

    static func from(_ startDate: Date, to endDate: Date, context: NSManagedObjectContext) -> [CECredit] {
        let request = CECredit.fetchRequest()
        let dateKeyPath = NSExpression(forKeyPath: \CECredit.date_).keyPath
        request.predicate = NSPredicate(
            format: "%K >= %@ && %K <= %@",
            dateKeyPath, startDate as NSDate,
            dateKeyPath, endDate as NSDate
        )
        return (try? context.fetch(request)) ?? []
    }

    convenience init?(creditProperties: [CELogProperty: String], context: NSManagedObjectContext) throws {
        for CEProperty in CELogProperty.allCases {
            guard creditProperties[CEProperty] != nil else {
                throw CECreditError.missingProperty(CEProperty)
            }
        }

        // Ignore duplicate entries
        if let uan = creditProperties[.UAN], CECredit.with(UAN: uan, context: context) != nil {
            return nil
        }

        self.init(entity: CECredit.entity(), insertInto: context)

        uan = creditProperties[.UAN]!
        creditType = creditProperties[.creditType]!
        source = creditProperties[.source]!
        title = creditProperties[.title]!
        provider = creditProperties[.provider]!

        let designatorCode = Self.getTopicDesignatorCode(UAN: uan)
        let designatorTitle = creditProperties[.topicDesignators]!
        if let topicDesignator = CETopicDesignator(topicDesignatorCode: designatorCode, topicString: designatorTitle) {

            self.topicDesignator = topicDesignator
        } else {
            throw CECreditError.invalidTopicDesignator
        }

        let liveHoursStr = creditProperties[.liveHours] ?? "0"
        liveHours = Float(liveHoursStr) ?? 0
        let homeHoursStr = creditProperties[.homeHours] ?? "0"
        homeHours = Float(homeHoursStr) ?? 0

        let dateStr = creditProperties[.date]!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if let date = dateFormatter.date(from: dateStr) {
            self.date = date
        } else {
            throw CECreditError.invalidDate
        }
    }

    var date: Date {
        get { date_! }
        set { date_ = newValue }
    }

    var uan: String {
        get { uan_! }
        set { uan_ = newValue }
    }

    var creditType: String {
        get { creditType_! }
        set { creditType_ = newValue }
    }

    var source: String {
        get { source_! }
        set { source_ = newValue }
    }

    var title: String {
        get { title_! }
        set { title_ = newValue }
    }

    var provider: String {
        get { provider_! }
        set { provider_ = newValue }
    }

    var topicDesignator: CETopicDesignator {
        get {
            let CDtopicDesigntor = topicDesignator_!
            return CETopicDesignator(topicDesignatorCode: CDtopicDesigntor.code, topicString: CDtopicDesigntor.title) ?? .additional("Unknown")
        }
        set {
            guard let context = self.managedObjectContext else { return }
            let enumDesignator = newValue
            topicDesignator_ = TopicDesignator.from(enumDesignator, context: context)
        }
    }

    var totalHours: Float { liveHours + homeHours }
}
