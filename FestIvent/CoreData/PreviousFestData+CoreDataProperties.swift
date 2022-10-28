//
//  PreviousFestData+CoreDataProperties.swift
//  FestIvent
//
//  Created by mac on 28.10.22.
//
//

import Foundation
import CoreData


extension PreviousFestData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PreviousFestData> {
        return NSFetchRequest<PreviousFestData>(entityName: "PreviousFestData")
    }

    @NSManaged public var festDate: String?
    @NSManaged public var festDescr: String?
    @NSManaged public var festIMGTag: String?
    @NSManaged public var festPlace: String?
    @NSManaged public var festTitle: String?

}

extension PreviousFestData : Identifiable {

}
