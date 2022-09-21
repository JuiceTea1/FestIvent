//
//  ScreenAVC.swift
//  FestIvent
//
//  Created by mac on 6.10.22.
//

import UIKit
import CoreData

class ScreenAVC: UIViewController {
    
    @IBOutlet weak var tableViewA: UITableView!
    
    @IBOutlet weak var navItemA: UINavigationItem!
    
    @IBOutlet weak var calendarButtonItem: UIBarButtonItem!
    
    let networkManager = NetworkManager()
    
    lazy var coreDataManager = CoreDataManager(modelName: "FestCoreData")
    
    lazy var predicate = NSPredicate(format: "festTitle contains'В'")
//    MARK: Fetched result controller
    lazy var fetchedRC: NSFetchedResultsController<FestData> = {
        let fetchedRequest = FestData.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "festTitle", ascending: true)
        fetchedRequest.sortDescriptors = [sortDescriptor]
//        fetchedRequest.predicate = predicate
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: coreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }()
//    MARK: wiewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.addData()
        tuneUI()
        performFetchedRC()
    }
// MARK: tuneUI
    func tuneUI() {
        let nibCell = UINib(nibName: "CustomCell", bundle: nil)
        tableViewA.register(nibCell, forCellReuseIdentifier: "cell")
        tableViewA.dataSource = self
        tableViewA.delegate = self
        tableViewA.rowHeight = 150
        
//        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func performFetchedRC() {
        do {
            try fetchedRC.performFetch()
        } catch {
            print(error)
        }
    }
// MARK: Date Formatter
    private func getDateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MM-dd-yyyy", options: 0, locale: Locale(identifier: "ru-RU"))
        return dateFormatter.string(from: date)
    }

}

extension ScreenAVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedRC.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        let fest = fetchedRC.object(at: indexPath)
        cell.capitalImageView.image = UIImage(named: fest.festIMGTag!)
        cell.titleLabel.text = fest.festTitle
        cell.dateLabel.text = getDateString(from: fest.festDate!)
        cell.placeLabel.text = fest.festPlace
        cell.priceLabel.text = String(fest.festTicketPrice) + "р"
        return cell
    }
    
    
}
