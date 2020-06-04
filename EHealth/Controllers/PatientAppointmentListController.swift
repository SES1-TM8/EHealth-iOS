//
//  PatientAppointmentListController.swift
//  EHealth
//
//  Created by Jon McLean on 2/6/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class PatientAppointmentListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let api = API.shared
    
    var user: User
    var patient: Patient
    var session: Session?
    
    var appointments: [Appointment] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var tableView: UITableView = UITableView()
    
    var noAppointmentsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Oswald-ExtraLight", size: 26)
        label.numberOfLines = 0
        label.text = "You have no appointments"
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
        
        self.loadAppointments()
        
        tableView.backgroundColor = Theme.background
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AppointmentCell.self, forCellReuseIdentifier: DoctorAppointmentListControllerController.cellId)
        
        self.view.addSubview(tableView)
        self.view.addSubview(noAppointmentsLabel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.navigationItem.setLeftBarButton(UIBarButtonItem(title: "", style: .plain, target: nil, action: nil), animated: true)
        self.tabBarController?.navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(addAppointment)), animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let header = tableView.tableHeaderView {
            let newSize = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            header.frame.size.height = newSize.height
        }
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        noAppointmentsLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.width.equalTo(self.view.bounds.width - 75)
        }
    }
    
    func loadAppointments() {
        api.getAppointmentsForPatient(token: self.session!.token, success: { (response) in
            if let model = try? JSONDecoder().decode([Appointment].self, from: response) {
                self.appointments = model
                
            }
        }) { (error) in
            print("failure")
        }
    }
    
    @objc func addAppointment() {
        self.navigationController?.pushViewController(PatientViewDoctorsController(user: self.user, patient: self.patient), animated: true)
    }
    
    // MARK: - UITableView Delegate/DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if appointments.count == 0 {
            self.tableView.isHidden = true
            self.noAppointmentsLabel.isHidden = false
        }else {
            self.tableView.isHidden = false
            self.noAppointmentsLabel.isHidden = true
        }
        
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
        
        api.getDoctor(doctorId: appointment.doctorId, success: { (response) in
            if let model = try? JSONDecoder().decode(DoctorAPI.self, from: response) {
                
                self.api.getUser(userId: model.userId, success: { (userResponse) in
                    if let user = try? JSONDecoder().decode(User.self, from: userResponse) {
                        cell.patientName = user.firstName + " " + user.lastName
                        cell.initials = "\(user.firstName) \(user.lastName)".initials()
                    }
                }) { (error) in
                    print("failed to get user")
                    cell.patientName = "Doctor"
                    cell.initials = "DR"
                }
                
            }
        }) { (error) in
            print("failure")
            cell.patientName = "Doctor"
            cell.initials = "DR"
        }
        
        cell.setTime(date: Date(timeIntervalSince1970: Double(appointment.start / 1000)))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DoctorHomeController.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        api.getAppointmentInfo(token: session!.token, appointmentId: appointments[indexPath.row].id, success: { (response) in
            if let model = try? JSONDecoder().decode(AppointmentInformation.self, from: response) {
                self.navigationController?.pushViewController(AppointmentController(user: self.user, patient: self.patient, appointment: self.appointments[indexPath.row], info: model), animated: true)
            }
        }) { (error) in
            print("failure")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
