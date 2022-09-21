//
//  NetworkManager.swift
//  FestIvent
//
//  Created by mac on 16.10.22.
//

import Foundation
import CoreData

//    MARK: Получение данных из JSON и загрузка их в БД
class NetworkManager {
    
    lazy var coreDataManager = CoreDataManager(modelName: "FestCoreData")

    lazy var fetchedCheckData: [CheckData] = []
    lazy var fetchedFestData: [FestData] = []
    
    func addData() {
        let url = Bundle.main.url(forResource: "festJson", withExtension: "json")
        
        do {
            let dataJSON = try Data(contentsOf: url!)
            
            do {
                fetchedCheckData = try self.coreDataManager.context.fetch(CheckData.fetchRequest())
            } catch {
                print(error)
            }
            print("объем объекта: \(fetchedCheckData.first?.dataCounter ?? 0)")
            print("объем json: \(dataJSON.count)")
            print("колво объектов в БД: \(fetchedCheckData.count)")
            guard fetchedCheckData.first?.dataCounter != Int16(dataJSON.count) else {
                return
            }
//            MARK: Создание Entity для первого заполения БД
            if fetchedCheckData.first?.dataCounter == nil {
                let savedHash = CheckData(context: self.coreDataManager.context)
                savedHash.dataCounter = Int16(dataJSON.count)
            }
//            MARK: обновление БД в случае изменения JSON
            if fetchedCheckData.first?.dataCounter != nil {
                let objectUpdate = fetchedCheckData[0] as NSManagedObject
                objectUpdate.setValue(Int16(dataJSON.count), forKey: "dataCounter")
                do {
                    fetchedFestData = try self.coreDataManager.context.fetch(FestData.fetchRequest())
                } catch {
                    print(error)
                }
                fetchedFestData.forEach { entity in
                    self.coreDataManager.context.delete(entity)
                }
            }
            self.coreDataManager.saveContext { error in
                guard error == nil else {
                    return
                }
            }
//            MARK: Заполнение БД из JSONa
                let result = try JSONDecoder().decode([FestDataForJSON].self, from: dataJSON)
                result.forEach { festJSON in
                    let fest = FestData(context: self.coreDataManager.context)
                    fest.festIMGTag = festJSON.festIMGTag
                    fest.festDate = getDate(from: festJSON.festDate!)
                    fest.festTitle = festJSON.festTitle
                    fest.festTicketPrice = festJSON.festTicketPrice
                    fest.festAvailableTickets = festJSON.festAvailableTickets
                    fest.festPlace = festJSON.festPlace
                    fest.festDescr = festJSON.festDescr
                    self.coreDataManager.saveContext { error in
                        guard error == nil else {
                            return
                        }
                    }
                }
        } catch {
            print(error)
        }
    }
//    MARK: Date Formatter
    private func getDate(from string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MM-dd-yyyy", options: 0, locale: Locale(identifier: "ru-RU"))
        return dateFormatter.date(from: string)!
    }
}

