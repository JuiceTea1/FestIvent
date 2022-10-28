//
//  CalendarView.swift
//  FestIvent
//
//  Created by mac on 20.10.22.
//

import UIKit

class CalendarView: UIView {
    
    lazy var fetchedChoosedDate: [ChoosedDate] = []
    
    lazy var coreDataManager = CoreDataManager.shared
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .inline
        picker.datePickerMode = .date
        picker.minimumDate = Date().addingTimeInterval(-365*24*60*60)
        picker.maximumDate = Date().addingTimeInterval(2*365*24*60*60)
        picker.countDownDuration = 2*60
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    var exitController: (() -> ())
    
    init(closeCalendar: @escaping (() -> ())) {
        self.exitController = closeCalendar
        super.init(frame: .zero)
        tuneInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tuneInit() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemGroupedBackground
        layer.cornerRadius = 15
        layer.cornerCurve = .continuous
        fetchChoosedDate()
        if let date = fetchedChoosedDate[0].date {
            datePicker.setDate(date, animated: true)
        }
        datePicker.addTarget(self, action: #selector(datePickerChange(paramDatePicker:)), for: .valueChanged)
        addSubview(datePicker)
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
    
    @objc private func datePickerChange(paramDatePicker: UIDatePicker) {
        let titleForDate = MyDateFormatter.getDateString(from: datePicker.date)
        NetworkManager().chooseDate(date: datePicker.date)
        
        NotificationCenter.default.post(name: NSNotification.Name("CalendarView"), object: titleForDate)
        exitController()
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        let constants = [
        datePicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
        datePicker.topAnchor.constraint(equalTo: topAnchor, constant: 0),
        datePicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(constants)
    }
    
}
