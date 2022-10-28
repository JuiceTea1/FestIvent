//
//  ScreenAVC.swift
//  FestIvent
//
//  Created by mac on 6.10.22.
//

import UIKit

class ScreenAVC: UIViewController {
    
    @IBOutlet weak var tableViewA: UITableView!
    
    @IBOutlet weak var listTabBar: UITabBarItem!
    
    @IBOutlet weak var calendarBarButton: UIBarButtonItem!
    
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    lazy var coreDataManager = CoreDataManager.shared
    
    lazy var fetchedFestData: [FestData] = []
    
    lazy var fetchedChoosedDate: [ChoosedDate] = []
    
    lazy var datePredicate = MyDateFormatter.getDateString(from: fetchedChoosedDate[0].date ?? Date.now)
    lazy var nilPredicate: String = ""

//    MARK: wiewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchChoosedDate()
        tuneUI()
        fetchDataFest()
        NotificationCenter.default.addObserver(self, selector: #selector(updateTitle(for:)), name: NSNotification.Name("CalendarView"), object: nil)

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
        calendarBarButton.image = UIImage(systemName: "calendar")
        leftBarButton.image = UIImage(systemName: "line.3.horizontal")
    }
    
    @objc private func updateTitle(for notify: NSNotification) {
        if let text = notify.object as? String {
            self.nilPredicate = "not nil"
            self.navigationBar.topItem?.title = text
            self.datePredicate = text
            fetchDataFest()
        }
    }
    //    MARK: Fetch request for FestData
    func fetchDataFest() {
        let fetchRequest = FestData.fetchRequest()
        if nilPredicate != "" {
            lazy var predicate = NSPredicate(format: "festDate = %@", "\(self.datePredicate)")
            fetchRequest.predicate = predicate
        }
        let sortDescriptor = NSSortDescriptor(key: "festDateSort", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            fetchedFestData = try coreDataManager.context.fetch(fetchRequest)
            tableViewA.reloadData()
        }
        catch {
            print(error)
        }
    }
    
    func fetchChoosedDate() {
        let fetchRequest = ChoosedDate.fetchRequest()
        do {
            fetchedChoosedDate = try coreDataManager.context.fetch(fetchRequest)
        }
        catch {
            print(error)
        }
    }
}

extension ScreenAVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedFestData.count
    }
//    MARK: Заполнение таблицы даными из CoreData
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        let fest = fetchedFestData[indexPath.row]
        cell.capitalImageView.image = UIImage(named: fest.festIMGTag!)
        cell.titleLabel.text = fest.festTitle
        cell.dateLabel.text = fest.festDate
        cell.placeLabel.text = fest.festPlace
        cell.priceLabel.text = String(fest.festTicketPrice) + "р"
        return cell
    }
//    MARK: Переход на страницу концерта
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let vc = storyboard?.instantiateViewController(identifier: "descr") as? ScreenCVC else {
            return nil
        }
        vc.festData = fetchedFestData[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        return indexPath
    }
}

