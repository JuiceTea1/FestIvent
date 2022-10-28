//
//  FestData+CoreDataProperties.swift
//  FestIvent
//
//  Created by mac on 28.10.22.
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
    @NSManaged public var isInFavourites: Bool
    @NSManaged public var festDateSort: Date?
    @NSManaged public var festArtists: String?

}

extension FestData : Identifiable {

}
