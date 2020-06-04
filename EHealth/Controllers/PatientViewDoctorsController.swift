//
//  PatientViewDoctorsController.swift
//  EHealth
//
//  Created by Jon McLean on 2/6/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class PatientViewDoctorsController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let api = API.shared
    
    var user: User
    var patient: Patient
    var session: Session?
    
    var doctors: [DoctorAPI] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var tableView: UITableView = UITableView()
    
    var noDoctorsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Oswald-ExtraLight", size: 26)
        label.numberOfLines = 0
        label.text = "No doctors registered"
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.black.withAlphaComponent(0.4)
        label.isHidden = true
        label.textAlignment = .center
        
        return label
    }()
    
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
        
        self.view.backgroundColor = Theme.background
        
        if let s = Session.load() {
            self.session = s
        }else {
            self.navigationController?.pushViewController(LoginController(), animated: true)
        }
        
        loadDoctors()
        
        tableView.backgroundColor = Theme.background
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AppointmentCell.self, forCellReuseIdentifier: DoctorAppointmentListControllerController.cellId)
        
        self.view.addSubview(tableView)
        self.view.addSubview(noDoctorsLabel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        noDoctorsLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.width.equalTo(self.view.bounds.width - 75)
        }
    }
    
    func loadDoctors() {
        
        api.getAllDoctors(success: { (response) in
            if let model = try? JSONDecoder().decode([DoctorAPI].self, from: response) {
                self.doctors = model
            }
        }) { (error) in
            print("failure")
        }
        
    }

    // MARK: - UITableView Delegate/DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if doctors.count == 0 {
            self.tableView.isHidden = true
            self.noDoctorsLabel.isHidden = false
        }else {
            self.tableView.isHidden = false
            self.noDoctorsLabel.isHidden = true
        }
        
        return doctors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: AppointmentCell
        
        if let dequeue = tableView.dequeueReusableCell(withIdentifier: DoctorAppointmentListControllerController.cellId, for: indexPath) as? AppointmentCell {
            cell = dequeue
        }else {
            cell = AppointmentCell(reuseId: DoctorAppointmentListControllerController.cellId)
        }
        
        let doctor = self.doctors[indexPath.row]
        
        api.getUser(userId: doctor.userId, success: { (response) in
            if let model = try? JSONDecoder().decode(User.self, from: response) {
                cell.initials = "\(model.firstName) \(model.lastName)".initials()
                cell.patientName = "\(model.firstName) \(model.lastName)"
            }
        }) { (error) in
            print("failure to get user")
            cell.initials = "DR"
            cell.patientName = "Doctor"
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DoctorHomeController.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(PatientDoctorProfileController(user: self.user, patient: self.patient, doctor: self.doctors[indexPath.row]), animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
