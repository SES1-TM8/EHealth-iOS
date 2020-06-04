//
//  PatientDoctorProfileController.swift
//  EHealth
//
//  Created by Jon McLean on 2/6/20.
//  Copyright © 2020 Jon McLean. All rights reserved.
//

import UIKit

class PatientDoctorProfileController: UIViewController {
    
    let api = API.shared
    
    var user: User
    var patient: Patient
    var doctor: DoctorAPI
    
    var session: Session?
    
    var nameInfo = InfoView()
    var phoneInfo = InfoView()
    var registrationInfo = InfoView()
    var hoursInfo = InfoView()
    
    var submitButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.layer.cornerRadius = 5.0
        button.setTitle("Book Appointment", for: .normal)
        button.titleLabel?.font = UIFont(name: "Oswald-Regular", size: 20)
        button.setTitleColor(Theme.secondary, for: .normal)
        button.backgroundColor = Theme.accent.withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(bookAppointment), for: .touchUpInside)
        
        return button
    }()
    
    init(user: User, patient: Patient, doctor: DoctorAPI) {
        self.user = user
        self.patient = patient
        self.doctor = doctor
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
        
        api.getUser(userId: doctor.userId, success: { (response) in
            if let model = try? JSONDecoder().decode(User.self, from: response) {
                self.nameInfo.title = "Doctor Name"
                self.nameInfo.content = "Dr. \(model.firstName) \(model.lastName)"
                
                self.phoneInfo.title = "Phone Number"
                self.phoneInfo.content = model.phoneNumber
            }else {
                self.navigationController?.popViewController(animated: true)
            }
        }) { (error) in
            print("failed to get user")
            self.navigationController?.popViewController(animated: true)
        }
        
        registrationInfo.title = "Registration Number"
        registrationInfo.content = doctor.registration
        
        hoursInfo.title = "Office Hours"
        
        api.getDoctorHours(doctorId: doctor.doctorId, success: { (response) in
            if let model = try? JSONDecoder().decode(OfficeHours.self, from: response) {
                if let beginDate = Date.convertTimestampFormatToDate(timestamp: model.startTime), let endDate = Date.convertTimestampFormatToDate(timestamp: model.endTime) {
                    self.hoursInfo.content = self.stringTime(date: beginDate) + " - " + self.stringTime(date: endDate)
                }else {
                    self.hoursInfo.content = "Unknown"
                }
            }
        }) { (error) in
            print("failed to get office hours")
            self.hoursInfo.content = "Unknown"
        }
        
        self.view.addSubview(nameInfo)
        self.view.addSubview(phoneInfo)
        self.view.addSubview(registrationInfo)
        self.view.addSubview(hoursInfo)
        self.view.addSubview(submitButton)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        nameInfo.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(Dimensions.Padding.extraLarge * 5)
            make.left.equalTo(self.view).offset(Dimensions.Padding.extraLarge)
            make.right.equalTo(self.view).offset(-Dimensions.Padding.extraLarge)
        }
        
        phoneInfo.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameInfo.snp.bottom).offset(Dimensions.Padding.extraLarge)
            make.left.equalTo(self.nameInfo)
            make.right.equalTo(self.nameInfo)
        }
        
        registrationInfo.snp.makeConstraints { (make) in
            make.top.equalTo(self.phoneInfo.snp.bottom).offset(Dimensions.Padding.extraLarge)
            make.left.equalTo(self.nameInfo)
            make.right.equalTo(self.nameInfo)
        }
        
        hoursInfo.snp.makeConstraints { (make) in
            make.top.equalTo(self.registrationInfo.snp.bottom).offset(Dimensions.Padding.extraLarge)
            make.left.equalTo(self.nameInfo)
            make.right.equalTo(self.nameInfo)
        }
        
        submitButton.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.bounds.width - 100)
            make.centerX.equalTo(self.view)
            make.height.equalTo(50)
            make.bottom.equalTo(self.view).offset(-Dimensions.Padding.extraLarge * 2)
        }
    }
    
    func stringTime(date: Date) -> String{
        let calendar = Calendar.current
        var hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        var timeExtension: String
        
        if hour > 12 {
            timeExtension = "PM"
            hour = hour - 12
        }else {
            timeExtension = "AM"
        }
        
        if minute < 10 {
            return "\(hour):0\(minute) \(timeExtension)"
        }else {
            return "\(hour):\(minute) \(timeExtension)"
        }
    }
    
    @objc func bookAppointment() {
        self.navigationController?.pushViewController(PatientBookAppointmentController(user: self.user, patient: self.patient, doctor: self.doctor), animated: true)
    }
    
}

extension Date {
    static func convertTimestampFormatToDate(timestamp: String) -> Date? {
        let formatter = DateFormatter()
        print(timestamp)
        formatter.dateFormat = "yyyy-MM-ddTHH:mm:ss.000+0000"
        return formatter.date(from: timestamp)
    }
    
    static func convertDateStringToDate(date: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: date)
    }
}
