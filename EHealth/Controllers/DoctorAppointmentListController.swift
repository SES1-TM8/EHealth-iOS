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
    
    let api = API.shared
    
    var user: User
    var doctor: DoctorAPI
    var appointments: [Appointment] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var session: Session?
    
    var tableView = UITableView()
    
    init(user: User, doctor: DoctorAPI) {
        self.user = user
        self.doctor = doctor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let s = Session.load() {
            self.session = s
        }else {
            self.navigationController?.pushViewController(LoginController(), animated: true)
        }
        
        self.view.backgroundColor = Theme.background
        
        tableView.backgroundColor = Theme.background
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AppointmentCell.self, forCellReuseIdentifier: DoctorAppointmentListControllerController.cellId)
        
        self.view.addSubview(tableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //self.navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(createAppointment)), animated: true)
        
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        self.loadAppointments()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    func loadAppointments() {
        api.getAppointmentsForDoctor(doctorId: self.doctor.doctorId, success: { (response) in
            if let model = try? JSONDecoder().decode([Appointment].self, from: response) {
                self.appointments = model
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
        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: AppointmentCell
        
        if let dequeue = tableView.dequeueReusableCell(withIdentifier: DoctorAppointmentListControllerController.cellId, for: indexPath) as? AppointmentCell {
            cell = dequeue
        }else {
            cell = AppointmentCell(reuseId: DoctorAppointmentListControllerController.cellId)
        }
        
        let app = appointments[indexPath.row]
        
        cell.initials = "PT"
        cell.patientName = "Patient"
        
        api.getPatientForId(id: app.patientId, success: { (response) in
            if let model = try? JSONDecoder().decode(Patient.self, from: response) {
                self.api.getUser(userId: model.userId, success: { (userResponse) in
                    if let userModel = try? JSONDecoder().decode(User.self, from: userResponse) {
                        cell.initials = "\(userModel.firstName) \(userModel.lastName)".initials()
                        cell.patientName = "\(userModel.firstName) \(userModel.lastName)"
                    }
                }) { (error) in
                    print("failed to get user")
                }
            }
        }) { (error) in
            print("failure to get patient")
        }
        
        cell.setTime(date: Date(timeIntervalSince1970: Double(app.start / 1000)))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DoctorHomeController.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        api.getAppointmentInfo(token: self.session!.token, appointmentId: appointments[indexPath.row].id, success: { (response) in
            if let model = try? JSONDecoder().decode(AppointmentInformation.self, from: response) {
                self.navigationController?.pushViewController(DoctorAppointmentController(user: self.user, doctor: self.doctor, appointment: self.appointments[indexPath.row], info: model), animated: true)
            }
        }) { (error) in
            print("Failed to get info")
        }
    }
}
