//
//  DoctorAppointmentListController.swift
//  EHealth
//
//  Created by Jon McLean on 1/4/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class DoctorAppointmentListControllerController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let cellId = "AppointmentCell"
    
    var doctor: Doctor
    var appointments: [Appointment] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var tableView = UITableView()
    
    init(doctor: Doctor) {
        self.doctor = doctor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = Theme.background
        
        tableView.backgroundColor = Theme.background
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AppointmentCell.self, forCellReuseIdentifier: DoctorAppointmentListControllerController.cellId)
        
        self.view.addSubview(tableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.appointments = [Appointment(patient: Patient(id: 0, name: "Joy Liu", phoneNumber: "999", email: "test@test.com", address: "", dateOfBirth: "12/05/2000", medicareNumber: "AAAAAAAAAA", concessionType: .generic, concessionCardNumber: "AAAAAA"), doctor: self.doctor, reason: nil, time: 1585735503, imageUrls: nil), Appointment(patient: Patient(id: 1, name: "Shane Rodrigues", phoneNumber: "999", email: "test@test.com", address: "", dateOfBirth: "12/03/2000", medicareNumber: "AAAAAA", concessionType: .none, concessionCardNumber: ""), doctor: self.doctor, reason: nil, time: 1585739103, imageUrls: nil), Appointment(patient: Patient(id: 2, name: "Ahmed Kursheed", phoneNumber: "999", email: "test@test.com", address: "", dateOfBirth: "31/03/1999", medicareNumber: "AAAAAAAA", concessionType: .none, concessionCardNumber: ""), doctor: self.doctor, reason: nil, time: 1585739103, imageUrls: nil), Appointment(patient: Patient(id: 3, name: "Zihao Cui", phoneNumber: "999", email: "test@test.com", address: "", dateOfBirth: "21/01/1997", medicareNumber: "AAAAAAAAAA", concessionType: .none, concessionCardNumber: ""), doctor: self.doctor, reason: nil, time: 1585739103, imageUrls: nil), Appointment(patient: Patient(id: 4, name: "Jon McLean", phoneNumber: "0435882119", email: "jon@mclean.one", address: "30 Letters Street, Evatt ACT 2617", dateOfBirth: "27/10/1999", medicareNumber: "AAAAAAAAAAA", concessionType: .none, concessionCardNumber: ""), doctor: self.doctor, reason: nil, time: 1585739103, imageUrls: nil)]
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    // MARK: - UITableView Delegate/DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: AppointmentCell
        
        if let dequeue = tableView.dequeueReusableCell(withIdentifier: DoctorAppointmentListControllerController.cellId, for: indexPath) as? AppointmentCell {
            cell = dequeue
        }else {
            cell = AppointmentCell(reuseId: DoctorAppointmentListControllerController.cellId)
        }
        
        let appointment = appointments[indexPath.row]
        cell.patientName = appointment.patient.name
        cell.initials = appointment.patient.name.initials() ?? "#"
        cell.setTime(date: Date(timeIntervalSince1970: appointment.time))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DoctorHomeController.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
