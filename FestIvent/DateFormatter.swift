//
//  DateFormatter.swift
//  FestIvent
//
//  Created by mac on 21.10.22.
//

import Foundation

// MARK: Date Formatter
class MyDateFormatter {
//    static let instance = MyDateFormatter()
    
//    private init() {}

        static func getDateString(from date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = .current
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MM-dd-yyyy", options: 0, locale: Locale(identifier: "ru-RU"))
            return dateFormatter.string(from: date)
        }
    
        static func getDate(from string: String) -> Date {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = .current
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MM-dd-yyyy", options: 0, locale: Locale(identifier: "ru-RU"))
            return dateFormatter.date(from: string)!
        }
}
