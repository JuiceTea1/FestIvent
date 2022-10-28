//
//  CoreDataManager.swift
//  FestIvent
//
//  Created by mac on 10.10.22.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    var modelName = "FestCoreData"
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { storeDescription, error in }
        return container
    }()
    lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
    
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

