//
//  CalendarViewController.swift
//  FestIvent
//
//  Created by mac on 20.10.22.
//

import UIKit

class CalendarViewController: UIViewController {

    lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return view
    }()
    lazy var customView = CalendarView { [weak self] in
        guard let self = self else {
            return
        }
        self.dismiss(animated: true) {
        }
    }
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundView)
        view.addSubview(customView)
        tuneUI()
        
    }

    func tuneUI() {
        
        var constants = [
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        constants.append(contentsOf: [
            customView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            customView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            customView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.51)
        ])
        NSLayoutConstraint.activate(constants)
    }
    
}

