//
//  CoreDataManager.swift
//  FestIvent
//
//  Created by mac on 10.10.22.
//

import Foundation
import CoreData

class CoreDataManager {
    var modelName = ""
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { storeDescription, error in }
        return container
    }()
    lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
    init(modelName: String = "") {
        self.modelName = modelName
    }
    func saveContext(completion: (Error?)->()) {
        guard context.hasChanges else {
            completion(CoreDataManagerError.noData)
            return
        }
        do {
            try context.save()
            completion(nil)
        } catch {
            completion(error)
        }
    }
}

enum CoreDataManagerError: Error {
    case noData
}

struct FestDataForJSON: Codable {
    var festAvailableTickets: Int16
    var festDate: String?
    var festDescr: String?
    var festPlace: String?
    var festTicketPrice: Int16
    var festTitle: String?
    var festIMGTag: String?
}
