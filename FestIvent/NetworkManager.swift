//
//  NetworkManager.swift
//  FestIvent
//
//  Created by mac on 16.10.22.
//

import Foundation
import CoreData


class NetworkManager {
    
    lazy var coreDataManager = CoreDataManager.shared

    lazy var fetchedCheckData: [CheckData] = []
    lazy var fetchedFestData: [FestData] = []
    lazy var fetchedChoosedDate: [ChoosedDate] = []
    
//    MARK: Получение данных из JSON и загрузка их в БД
    func addData() {
        let url = Bundle.main.url(forResource: "festJson", withExtension: "json")
        do {
            let dataJSON = try Data(contentsOf: url!)
            
            do {
                fetchedCheckData = try self.coreDataManager.context.fetch(CheckData.fetchRequest())
            } catch {
                print(error)
            }
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
                    fest.festDate = festJSON.festDate
                    fest.festTitle = festJSON.festTitle
                    fest.festTicketPrice = festJSON.festTicketPrice
                    fest.festAvailableTickets = festJSON.festAvailableTickets
                    fest.festPlace = festJSON.festPlace
                    fest.festDescr = festJSON.festDescr
                    fest.festDateSort = MyDateFormatter.getDate(from: festJSON.festDate ?? "")
                    fest.festArtists = festJSON.festArtists
//                    MARK: Костыль загрузки данных для предыдущего фестиваля
                    let prevFest = PreviousFestData(context: self.coreDataManager.context)
                    let dateMinusYear = Date(timeInterval: -60*60*24*365, since: MyDateFormatter.getDate(from: festJSON.festDate!))
                    prevFest.festDate = MyDateFormatter.getDateString(from: dateMinusYear)
                    prevFest.festTitle = festJSON.festTitle
                    prevFest.festDescr = festJSON.festDescr
                    prevFest.festIMGTag = festJSON.festIMGTag
                    prevFest.festPlace = festJSON.festPlace
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
    
//    MARK: загрузка выбранной даты в БД
    func chooseDate(date: Date) {
        do {
            fetchedChoosedDate = try self.coreDataManager.context.fetch(ChoosedDate.fetchRequest())
        } catch {
            print(error)
        }
        
//            MARK: Первоe заполение даты в БД
        if fetchedChoosedDate.first?.date == nil {
            let savedValue = ChoosedDate(context: self.coreDataManager.context)
            savedValue.date = date
        }
        
//            MARK: обновление даты в БД
        if fetchedChoosedDate.first?.date != nil {
            let objectUpdate = fetchedChoosedDate[0] as NSManagedObject
            objectUpdate.setValue(date, forKey: "date")
        }
        self.coreDataManager.saveContext { error in
            guard error == nil else {
                return
            }
        }
    }
    
//    MARK: добавление фестиваля в избранное
    func addToFavourites(_ festName: String) {
        do {
            fetchedFestData = try self.coreDataManager.context.fetch(FestData.fetchRequest())
        } catch {
            print(error)
        }
        fetchedFestData.forEach { entity in
            if entity.festTitle == festName {
                let entity = entity as NSManagedObject
                entity.setValue(true, forKey: "isInFavourites")
                self.coreDataManager.saveContext { error in
                    guard error == nil else {
                        return
                    }
                }
            }
        }
    }
    
//    MARK: удаление фестиваля из избранного
    func deleteFromFavourites(_ festName: String) {
        do {
            fetchedFestData = try self.coreDataManager.context.fetch(FestData.fetchRequest())
        } catch {
            print(error)
        }
        fetchedFestData.forEach { entity in
            if entity.festTitle == festName {
                let entity = entity as NSManagedObject
                entity.setValue(false, forKey: "isInFavourites")
                self.coreDataManager.saveContext { error in
                    guard error == nil else {
                        return
                    }
                }
            }
        }
    }
}

// MARK: codable для парсинга JSON
struct FestDataForJSON: Codable {
    var festAvailableTickets: Int16
    var festDate: String?
    var festDescr: String?
    var festPlace: String?
    var festTicketPrice: Int16
    var festTitle: String?
    var festIMGTag: String?
    var festDateSort: Date?
    var festArtists: String?
}
