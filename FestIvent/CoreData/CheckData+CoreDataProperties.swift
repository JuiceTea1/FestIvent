//
//  CheckData+CoreDataProperties.swift
//  FestIvent
//
//  Created by mac on 17.10.22.
//
//

import Foundation
import CoreData


extension CheckData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CheckData> {
        return NSFetchRequest<CheckData>(entityName: "CheckData")
    }

    @NSManaged public var dataCounter: Int16

}

extension CheckData : Identifiable {

}
