//
//  DoctorUrgentCaseListController.swift
//  EHealth
//
//  Created by Jon McLean on 4/6/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class DoctorUrgentCaseListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let cellId = "UrgentCaseCell"
    
    let api = API.shared
    
    var user: User
    var doctor: DoctorAPI
    var session: Session?
    
    var cases: [UrgentCase] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    init(user: User, doctor: DoctorAPI) {
        self.user = user
        self.doctor = doctor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let s = Session.load() {
            self.session = s
        }else {
            self.navigationController?.pushViewController(LoginController(), animated: true)
        }
        
        tableView.backgroundColor = Theme.background
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UrgentCaseCell.self, forCellReuseIdentifier: DoctorUrgentCaseListController.cellId)
        
        self.view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUrgentCases()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    func loadUrgentCases() {
        api.getUnresolvedCaes(token: session!.token, success: { (response) in
            if let model = try? JSONDecoder().decode([UrgentCase].self, from: response) {
                self.cases = model
            }
        }) { (error) in
            print("Failed to get urgent cases")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UrgentCaseCell
        
        if let dequeue = tableView.dequeueReusableCell(withIdentifier: DoctorUrgentCaseListController.cellId, for: indexPath) as? UrgentCaseCell {
            cell = dequeue
        }else {
            cell = UrgentCaseCell(reuseId: DoctorUrgentCaseListController.cellId)
        }
        
        api.getPatientForId(id: self.cases[indexPath.row].patientId, success: { (response) in
            if let model = try? JSONDecoder().decode(Patient.self, from: response) {
                self.api.getUser(userId: model.userId, success: { (userResponse) in
                    if let userModel = try? JSONDecoder().decode(User.self, from: userResponse) {
                        cell.setUrgentCase(urgentCase: self.cases[indexPath.row], patientUser: userModel)
                    }
                }) { (error) in
                    print("Failed to get user for patient")
                }
            }
        }) { (error) in
            print("failed to get patient")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        DoctorPatientMedicationsController.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        api.getGroupForAppointment(appointmentId: self.cases[indexPath.row].id, success: { (response) in
            if let model = try? JSONDecoder().decode(MessageGroup.self, from: response) {
                self.api.getPatientForId(id: self.cases[indexPath.row].patientId, success: { (patientResponse) in
                    if let patient = try? JSONDecoder().decode(Patient.self, from: patientResponse) {
                        self.api.getUser(userId: patient.userId, success: { (userResponse) in
                            if let userModel = try? JSONDecoder().decode(User.self, from: userResponse) {
                                self.navigationController?.pushViewController(DoctorUrgentChatController(user: self.user, doctor: self.doctor, messageGroup: model, urgentCase: self.cases[indexPath.row], patient: patient, patientUser: userModel), animated: true)
                            }
                        }) { (error) in
                            print("failed to get user")
                        }
                    }
                }) { (error) in
                    print("failed to get patient")
                }
            }
        }) { (error) in
            print("failed to get message group")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
