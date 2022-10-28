//
//  SearchVC.swift
//  FestIvent
//
//  Created by mac on 6.10.22.
//

import UIKit

class SearchVC: UIViewController {

    private let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableViewSRCH: UITableView!
    
    lazy var fetchedFestData: [FestData] = []
    lazy var coreDataManager = CoreDataManager.shared
    lazy var searchedFestData: [FestData] = []
    lazy var titlePredicate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tuneSearchController()
        tuneUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        titlePredicate = ""
        
    }
    func tuneUI() {
        let nibCell = UINib(nibName: "CustomCell", bundle: nil)
        tableViewSRCH.register(nibCell, forCellReuseIdentifier: "cell")
        tableViewSRCH.dataSource = self
        tableViewSRCH.delegate = self
        tableViewSRCH.rowHeight = 150
    }
    func tuneSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.searchTextField.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    //    MARK: Fetch request
        func fetchDataFest() {
            let fetchRequest = FestData.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "festDateSort", ascending: true)
            lazy var predicate = NSPredicate(format: "festTitle contains %@", "\(self.titlePredicate)")
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = [sortDescriptor]
            do {
                fetchedFestData = try coreDataManager.context.fetch(fetchRequest)
                tableViewSRCH.reloadData()
            }
            catch {
                print(error)
            }
        }
    

}

extension SearchVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        titlePredicate = text
        fetchDataFest()
    }
}

extension SearchVC: UITableViewDataSource, UITableViewDelegate {
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
