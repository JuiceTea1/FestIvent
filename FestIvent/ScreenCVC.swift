//
//  ScreenCVC.swift
//  FestIvent
//
//  Created by mac on 6.10.22.
//

import UIKit

class ScreenCVC: UIViewController {

    @IBOutlet weak var navigationItemTitle: UINavigationItem!
    
    @IBOutlet weak var leftBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var favouritesBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var tableViewC: UITableView!
    
    lazy var festData = FestData()
    
    lazy var textForCountdown: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tuneUI()
        countdownTimer()
    }
    
    func tuneUI() {
        let nibCell = UINib(nibName: "CustommCellC", bundle: nil)
        tableViewC.register(nibCell, forCellReuseIdentifier: "cellC")
        tableViewC.dataSource = self
        navigationItemTitle.title = festData.festTitle
        tableViewC.estimatedRowHeight = view.bounds.height
        favouritesBarButtonItem.image = festData.isInFavourites ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
    }
//    MARK: кнопка возврата к списку
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
//    MARK: Кнопка добавления в избранное
    @IBAction func addToFavourites(_ sender: UIBarButtonItem) {
        if festData.isInFavourites == true {
            favouritesBarButtonItem.image = UIImage(systemName: "star")
            NetworkManager().deleteFromFavourites(festData.festTitle!)
        } else {
            favouritesBarButtonItem.image = UIImage(systemName: "star.fill")
            NetworkManager().addToFavourites(festData.festTitle!)
            self.requestLocalNotification(festData.festTitle!)
        }
    }
//    MARK: кнопка "Поделиться"
    @IBAction func share(_ sender: UIBarButtonItem) {
        let text = "Приглашаю тебя посетить \(festData.festTitle ?? "")"
        let share = UIActivityViewController(activityItems: [UIImage(named: festData.festIMGTag!)!, text], applicationActivities: nil)
        present(share, animated: true)
    }
}
// MARK: tableView
extension ScreenCVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellC", for: indexPath) as! CustommCellC
        cell.titleImageView.image = UIImage(named: festData.festIMGTag!)
        cell.dateLabel.text = "Когда: " + (festData.festDate ?? "")
        cell.placeLabel.text = "Место: " + (festData.festPlace ?? "")
        cell.ticketLabel.text = String(festData.festTicketPrice) + " рублей"
        cell.descrLabel.text = festData.festDescr
        cell.countDownLabel.text = textForCountdown
        cell.artistsLabel.text = festData.festArtists
        return cell
    }
}

extension ScreenCVC {
//    MARK: Создание таймера до события
    func countdownTimer() {
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            DispatchQueue.main.async { [weak self] in
                let dayInterval = MyDateFormatter.getDate(from: self?.festData.festDate ?? "").timeIntervalSinceNow/60/60/24
                switch dayInterval {
                case 1...:
                    self?.textForCountdown = String("До старта: \(Int(ceil(dayInterval))) дня")
                    self?.tableViewC.reloadData()
                    timer.invalidate()
                case -1..<0:
                    self?.textForCountdown = "Событие идет"
                    self?.tableViewC.reloadData()
                    timer.invalidate()
                case 0..<1:
                    self?.textForCountdown = String("Событие уже завтра!")
                    self?.tableViewC.reloadData()
                    timer.invalidate()
                default :
                    self?.textForCountdown = "Событие закончилось"
                    self?.tableViewC.reloadData()
                    timer.invalidate()
                }
            }
        }
    }
//    MARK: Создание запроса оповещения о старте события
    func requestLocalNotification(_ body: String) {
        UNUserNotificationCenter.current().requestAuthorization(options: .alert) { [weak self] granted, error in
            guard granted == true else {
                return
            }
            self?.createNotification(body)
        }
    }
//    MARK: Создание оповещения
    func createNotification(_ body: String) {
        let content = UNMutableNotificationContent()
        content.title = "Завтра начинается"
        content.body = "\(body)"
        let date = MyDateFormatter.getDateInt(from: festData.festDate!)
        let dateComponents = DateComponents(calendar: .current, timeZone: .current, year: date[2], month: date[1], day: (date[0]-1), hour: 14, minute: 20)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let timeRequest = UNNotificationRequest(identifier: "id1", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(timeRequest)
    }
}
