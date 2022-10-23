//
//  ChoosedDate+CoreDataProperties.swift
//  FestIvent
//
//  Created by mac on 21.10.22.
//
//

import Foundation
import CoreData


extension ChoosedDate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChoosedDate> {
        return NSFetchRequest<ChoosedDate>(entityName: "ChoosedDate")
    }

    @NSManaged public var date: Date?

}

extension ChoosedDate : Identifiable {

}
