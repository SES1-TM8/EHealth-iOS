//
//  DoctorHomeController.swift
//  EHealth
//
//  Created by Jon McLean on 1/4/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class DoctorHomeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let cellId = "UpcomingCell"
    static let cellHeight: CGFloat = 90
    
    var doctor: Doctor
    var appointments: [Appointment] = [] {
        didSet {
            self.tableView.reloadData()
            self.remakeTableConstraints()
        }
    }
    
    var greetingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Oswald-SemiBold", size: 42)
        return label
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "Oswald-ExtraLight", size: 42)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        
        return label
    }()
    
    var infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Oswald-ExtraLight", size: 26)
        label.numberOfLines = 0
        label.text = "You have the following upcoming appointments today"
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.black.withAlphaComponent(0.4)
        
        return label
    }()
    
    var tableView = UITableView()
    
    var viewMoreButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "View all", attributes: [NSAttributedString.Key.font : UIFont(name: "Oswald-Regular", size: 18), NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)
        
        return button
    }()
    
    init(doctor: Doctor) {
        self.doctor = doctor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Theme.background
        
        greetingLabel.text = "Good \(timeBasedGreeting()),"
        nameLabel.text = "Dr. \(doctor.name.split(separator: " ").last ?? "")"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AppointmentCell.self, forCellReuseIdentifier: DoctorHomeController.cellId)
        tableView.backgroundColor = UIColor.clear
        tableView.isScrollEnabled = false
        
        self.view.addSubview(greetingLabel)
        self.view.addSubview(nameLabel)
        self.view.addSubview(infoLabel)
        self.view.addSubview(tableView)
        self.view.addSubview(viewMoreButton)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.appointments = [Appointment(patient: Patient(id: 0, name: "Joy Liu", phoneNumber: "999", email: "test@test.com", address: ""), doctor: self.doctor, reason: nil, time: 1585735503, imageUrls: nil), Appointment(patient: Patient(id: 0, name: "Shane Rodrigues", phoneNumber: "999", email: "test@test.com", address: ""), doctor: self.doctor, reason: nil, time: 1585739103, imageUrls: nil), Appointment(patient: Patient(id: 0, name: "Sally Wang", phoneNumber: "999", email: "test@test.com", address: ""), doctor: self.doctor, reason: nil, time: 1585739103, imageUrls: nil), Appointment(patient: Patient(id: 0, name: "Ahmed Kursheed", phoneNumber: "999", email: "test@test.com", address: ""), doctor: self.doctor, reason: nil, time: 1585739103, imageUrls: nil), Appointment(patient: Patient(id: 0, name: "Jon McLean", phoneNumber: "999", email: "test@test.com", address: ""), doctor: self.doctor, reason: nil, time: 1585739103, imageUrls: nil)]
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        greetingLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(Dimensions.Padding.extraLarge * 4)
            make.left.equalTo(self.view).offset(Dimensions.Padding.extraLarge * 2)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.greetingLabel.snp.bottom)
            make.left.equalTo(self.greetingLabel)
            make.right.equalTo(self.view).offset(-Dimensions.Padding.extraLarge * 2)
        }
        
        infoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(Dimensions.Padding.extraLarge)
            make.left.equalTo(self.nameLabel)
            make.right.equalTo(self.nameLabel)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.infoLabel.snp.bottom).offset(Dimensions.Padding.extraLarge)
            make.left.right.equalTo(self.view)
            
            let count: CGFloat = appointments.count <= 4 ? CGFloat(appointments.count) : 4.0
            make.height.equalTo(count * DoctorHomeController.cellHeight)
        }
        
        viewMoreButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.tableView.snp.bottom).offset(Dimensions.Padding.large)
            make.right.equalTo(self.view).offset(-Dimensions.Padding.large)
        }
    }
    
    private func remakeTableConstraints() {
        tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.infoLabel.snp.bottom).offset(Dimensions.Padding.extraLarge)
            make.left.right.equalTo(self.view)
            
            let count: CGFloat = appointments.count <= 4 ? CGFloat(appointments.count) : 4.0
            make.height.equalTo(count * DoctorHomeController.cellHeight)
        }
    }
    
    func timeBasedGreeting() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        if hour >= 12 && hour < 18 {
            return "afternoon"
        }else if hour >= 5 && hour < 12 {
            return "morning"
        }else {
            return "evening"
        }
    }
    
    // MARK: - Button Methods
    @objc func openAppointmentList() {
        self.tabBarController?.selectedIndex = 1
    }
    
    // MARK: - UITableView Delegate/DataSource Method
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if appointments.count <= 4 {
            self.viewMoreButton.isHidden = true
            return appointments.count
        }else {
            self.viewMoreButton.isHidden = false
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: AppointmentCell
        
        if let dequeue = tableView.dequeueReusableCell(withIdentifier: DoctorHomeController.cellId, for: indexPath) as? AppointmentCell {
            cell = dequeue
        }else {
            cell = AppointmentCell(reuseId: DoctorHomeController.cellId)
        }
        
        let app = appointments[indexPath.row]
        
        cell.patientName = app.patient.name
        cell.initials = app.patient.name.initials()
        cell.setTime(date: Date(timeIntervalSince1970: app.time))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DoctorHomeController.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension String {
    func initials() -> String? {
        let split = self.split(separator: " ")
        var initials = ""
        for i in split {
            if let f = i.first {
                initials.append(f)
            }
        }
        
        return initials.uppercased()
    }
}
