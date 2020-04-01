//
//  DoctorPatientListController.swift
//  EHealth
//
//  Created by Jon McLean on 1/4/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class DoctorPatientListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let cellId = "PatientCell"
    static let cellHeight: CGFloat = 90
    
    var doctor: Doctor
    var patients: [Patient] = [] {
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
        tableView.register(PatientCell.self, forCellReuseIdentifier: DoctorPatientListController.cellId)
        
        self.view.addSubview(tableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.patients = [Patient(id: 0, name: "Joy Liu", phoneNumber: "999", email: "test@test.com", address: "", dateOfBirth: "12/05/2000", medicareNumber: "AAAAAAAAAA", concessionType: .generic, concessionCardNumber: "AAAAAA"), Patient(id: 1, name: "Shane Rodrigues", phoneNumber: "999", email: "test@test.com", address: "", dateOfBirth: "12/03/2000", medicareNumber: "AAAAAA", concessionType: .none, concessionCardNumber: ""), Patient(id: 2, name: "Ahmed Kursheed", phoneNumber: "999", email: "test@test.com", address: "", dateOfBirth: "31/03/1999", medicareNumber: "AAAAAAAA", concessionType: .none, concessionCardNumber: ""), Patient(id: 3, name: "Zihao Cui", phoneNumber: "999", email: "test@test.com", address: "", dateOfBirth: "21/01/1997", medicareNumber: "AAAAAAAAAA", concessionType: .none, concessionCardNumber: ""), Patient(id: 4, name: "Jon McLean", phoneNumber: "0435882119", email: "jon@mclean.one", address: "30 Letters Street, Evatt ACT 2617", dateOfBirth: "27/10/1999", medicareNumber: "AAAAAAAAAAA", concessionType: .none, concessionCardNumber: "")]
        
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
        return self.patients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: PatientCell
        
        if let dequeue = tableView.dequeueReusableCell(withIdentifier: DoctorPatientListController.cellId, for: indexPath) as? PatientCell {
            cell = dequeue
        }else {
            cell = PatientCell(reuseId: DoctorPatientListController.cellId)
        }
        
        let patient = self.patients[indexPath.row]
        
        cell.patientName = patient.name
        cell.initials = patient.name.initials()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DoctorPatientListController.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DoctorPatientTabController(doctor: self.doctor, patient: self.patients[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
