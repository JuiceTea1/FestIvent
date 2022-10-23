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
    
    @IBOutlet weak var listTabBar: UITabBarItem!
    
    @IBOutlet weak var calendarBarButton: UIBarButtonItem!

    @IBOutlet weak var navigationBar: UINavigationBar!
    
    lazy var coreDataManager = CoreDataManager(modelName: "FestCoreData")
    
//    lazy var dateNowString = MyDateFormatter.getDateString(from: Date.now)
    lazy var datePredicate = MyDateFormatter.getDateString(from: Date.now)
    
//    MARK: Fetched result controller for FestData
    lazy var fetchedRC: NSFetchedResultsController<FestData> = {
        lazy var predicate = NSPredicate(format: "festDate = %@", "\(self.datePredicate)")
        print(predicate)
        let fetchedRequest = FestData.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "festDate", ascending: true)
        fetchedRequest.sortDescriptors = [sortDescriptor]
        fetchedRequest.predicate = predicate
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: coreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        return fetchedResultController
    }()
    
//    lazy var fetchedChoosedDate: [ChoosedDate] = []
    lazy var fetchedRCDate: NSFetchedResultsController<ChoosedDate> = {
        let fetchedRequest = ChoosedDate.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchedRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: coreDataManager.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        return fetchedResultController
    }()
    
//    MARK: wiewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tuneUI()
        performFetchedRC()
        NotificationCenter.default.addObserver(self, selector: #selector(updateTitle(for:)), name: NSNotification.Name("CalendarView"), object: nil)
//        fetchChoosedDate()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        performFetchedRC()
        tableViewA.reloadData()
    }

    @IBAction func showCalendar(_ sender: UIBarButtonItem) {
        present(CalendarViewController(), animated: true)
    }
    
    // MARK: tuneUI
    func tuneUI() {
        let nibCell = UINib(nibName: "CustomCell", bundle: nil)
        tableViewA.register(nibCell, forCellReuseIdentifier: "cell")
        tableViewA.dataSource = self
        tableViewA.delegate = self
        tableViewA.rowHeight = 150
        listTabBar.image = UIImage(systemName: "list.dash")
        calendarBarButton.image = UIImage(systemName: "calendar")
       
//        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc private func updateTitle(for notify: NSNotification) {
        if let text = notify.object as? String {
            self.navigationBar.topItem?.title = text
            self.datePredicate = text
            performFetchedRC()
            tableViewA.reloadData()
        }
    }
    
    func performFetchedRC() {
        do {
            try fetchedRC.performFetch()
            try fetchedRCDate.performFetch()
        } catch {
            print(error)
        }
    }
//    func fetchChoosedDate() {
//        do {
//            fetchedChoosedDate = try self.coreDataManager.context.fetch(ChoosedDate.fetchRequest())
//        } catch {
//            print(error)
//        }
//    }
}

extension ScreenAVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedRC.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        let fest = fetchedRC.object(at: indexPath)
        print(fest.festDate)
        cell.capitalImageView.image = UIImage(named: fest.festIMGTag!)
        cell.titleLabel.text = fest.festTitle
        cell.dateLabel.text = fest.festDate
        cell.placeLabel.text = fest.festPlace
        cell.priceLabel.text = String(fest.festTicketPrice) + "р"
        return cell
    }
    
    
}
extension ScreenAVC: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("work")
        tableViewA.reloadData()
        }
        

}
