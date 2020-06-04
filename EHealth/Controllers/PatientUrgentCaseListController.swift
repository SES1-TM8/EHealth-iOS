//
//  PatientUrgentCaseListController.swift
//  EHealth
//
//  Created by Jon McLean on 4/6/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class PatientUrgentCaseListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let cellId = "UrgentCell"
    
    let api = API.shared
    
    var user: User
    var patient: Patient
    var session: Session?
    
    var cases: [UrgentCase] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var tableView = UITableView()
    
    init(user: User, patient: Patient) {
        self.user = user
        self.patient = patient
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        tableView.register(UrgentCaseCell.self, forCellReuseIdentifier: PatientUrgentCaseListController.cellId)
        
        self.view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(createNewUrgentCase)), animated: true)
        
        loadUrgentCases()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
    }
    
    func loadUrgentCases() {
        api.getUrgentCases(token: session!.token, success: { (response) in
            if let model = try? JSONDecoder().decode([UrgentCase].self, from: response) {
                self.cases = model
            }
        }) { (error) in
            print("failure getting urgent cases")
        }
    }
    
    @objc func createNewUrgentCase() {
        self.navigationController?.pushViewController(PatientCreateCaseController(user: self.user, patient: self.patient), animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UrgentCaseCell
        
        if let dequeue = tableView.dequeueReusableCell(withIdentifier: PatientUrgentCaseListController.cellId, for: indexPath) as? UrgentCaseCell {
            cell = dequeue
        }else {
            cell = UrgentCaseCell(reuseId: PatientUrgentCaseListController.cellId)
        }
        
        cell.setUrgentCase(urgentCase: self.cases[indexPath.row], patientUser: self.user)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DoctorPatientMedicationsController.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        api.getGroupForAppointment(appointmentId: self.cases[indexPath.row].id, success: { (response) in
            if let model = try? JSONDecoder().decode(MessageGroup.self, from: response) {
                self.navigationController?.pushViewController(PatientUrgentChatController(user: self.user, patient: self.patient, messageGroup: model, urgentCase: self.cases[indexPath.row]), animated: true)
            }
        }) { (error) in
            print("failed to get message group")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
