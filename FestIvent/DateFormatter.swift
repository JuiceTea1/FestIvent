//
//  DateFormatter.swift
//  FestIvent
//
//  Created by mac on 21.10.22.
//

import Foundation

// MARK: Date Formatter
class MyDateFormatter {
    
        static func getDateString(from date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = .gmt
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MM-dd-yyyy", options: 0, locale: Locale(identifier: "ru-RU"))
            return dateFormatter.string(from: date)
        }
    
        static func getDate(from string: String) -> Date {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = .gmt
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MM-dd-yyyy", options: 0, locale: Locale(identifier: "ru-RU"))
            return dateFormatter.date(from: string)!
        }
    static func getDateInt(from string: String) -> [Int] {
        let arrStr = string.components(separatedBy: ".")
        var arrInt: [Int] = []
        arrStr.forEach {
            arrInt.append(Int($0)!)
        }
            return arrInt
    }
}
