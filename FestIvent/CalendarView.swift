//
//  CalendarView.swift
//  FestIvent
//
//  Created by mac on 20.10.22.
//

import UIKit

class CalendarView: UIView {
    
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
            picker.preferredDatePickerStyle = .inline
            picker.datePickerMode = .date
        return picker
    }()
    
    var exitController: (() -> ())
    
    init(closeCalendar: @escaping (() -> ())) {
        self.exitController = closeCalendar
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemGroupedBackground
        layer.cornerRadius = 15
        layer.cornerCurve = .continuous
        datePicker.addTarget(self, action: #selector(datePickerChange(paramDatePicker:)), for: .valueChanged)
        addSubview(datePicker)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    @objc func datePickerChange(paramDatePicker: UIDatePicker) {
        let titleForDate = MyDateFormatter.getDateString(from: datePicker.date)
        NetworkManager().chooseDate(date: datePicker.date)
        NotificationCenter.default.post(name: NSNotification.Name("CalendarView"), object: titleForDate)
        exitController()
    }

    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        let constants = [
//        datePicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
//        datePicker.topAnchor.constraint(equalTo: topAnchor, constant: 0),
//        datePicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
//        ]
//        NSLayoutConstraint.activate(constants)
//    }
    
}
