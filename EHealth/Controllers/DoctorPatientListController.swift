//
//  DoctorPatientListController.swift
//  EHealth
//
//  Created by Jon McLean on 1/4/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class DoctorPatientListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let api = API.shared
    
    static let cellId = "PatientCell"
    static let cellHeight: CGFloat = 90
    
    var user: User
    var doctor: DoctorAPI
    var patients: [Patient] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    
    var tableView = UITableView()
    
    init(user: User, doctor: DoctorAPI) {
        self.user = user
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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        loadPatients()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    func loadPatients() {
        api.getAppointmentsForDoctor(doctorId: self.doctor.doctorId, success: { (response) in
            if let model = try? JSONDecoder().decode([Appointment].self, from: response) {
                for i in model {
                    self.api.getPatientForId(id: i.patientId, success: { (patientResponse) in
                        if let patientModel = try? JSONDecoder().decode(Patient.self, from: patientResponse) {
                            if !self.patients.contains(where: { (p) -> Bool in
                                p.id == patientModel.id
                            }) {
                                self.patients.append(patientModel)
                            }
                        }
                    }) { (error) in
                        print("failed to patient")
                    }
                }
            }
        }) { (error) in
            print("failed to get appointments")
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
        
        cell.initials = "PT"
        cell.patientName = "Patient"
        
        self.api.getUser(userId: patient.userId, success: { (userResponse) in
            if let userModel = try? JSONDecoder().decode(User.self, from: userResponse) {
                cell.initials = "\(userModel.firstName) \(userModel.lastName)".initials()
                cell.patientName = "\(userModel.firstName) \(userModel.lastName)"
            }
        }) { (error) in
            print("failed to get user")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DoctorPatientListController.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DoctorPatientTabController(user: user, doctor: self.doctor, patient: self.patients[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
