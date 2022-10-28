//
//  ScreenBVC.swift
//  FestIvent
//
//  Created by mac on 6.10.22.
//

import UIKit

class ScreenBVC: UIViewController {

    @IBOutlet weak var tableViewB: UITableView!
    
    lazy var fetchedFestData: [FestData] = []
    lazy var coreDataManager = CoreDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tuneUI()
        fetchDataFest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchDataFest()
        tableViewB.reloadData()
    }
    
    func tuneUI() {
        let nibCell = UINib(nibName: "CustomCell", bundle: nil)
        tableViewB.register(nibCell, forCellReuseIdentifier: "cell")
        tableViewB.dataSource = self
        tableViewB.delegate = self
        tableViewB.rowHeight = 150
    }
    
//    MARK: Fetch request
    func fetchDataFest() {
        let fetchRequest = FestData.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "festDateSort", ascending: true)
        lazy var predicate = NSPredicate(format: "isInFavourites = true")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            fetchedFestData = try coreDataManager.context.fetch(fetchRequest)
            tableViewB.reloadData()
        }
        catch {
            print(error)
        }
    }

}

extension ScreenBVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedFestData.count
    }
    
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
