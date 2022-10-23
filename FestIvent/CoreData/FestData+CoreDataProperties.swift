//
//  FestData+CoreDataProperties.swift
//  FestIvent
//
//  Created by mac on 23.10.22.
//
//

import Foundation
import CoreData


extension FestData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FestData> {
        return NSFetchRequest<FestData>(entityName: "FestData")
    }

    @NSManaged public var festAvailableTickets: Int16
    @NSManaged public var festDate: String?
    @NSManaged public var festDescr: String?
    @NSManaged public var festIMGTag: String?
    @NSManaged public var festPlace: String?
    @NSManaged public var festTicketPrice: Int16
    @NSManaged public var festTitle: String?

}

extension FestData : Identifiable {

}
